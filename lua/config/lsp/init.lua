---@module 'vim.lsp._meta'

local Clients = require('config.lsp.servers')
local uv = vim.uv or vim.loop
local User = require('user_api')

---@generic T: table, F
---@param t T
---@param k any
---@param fallback F
---@return F fallback
local function get(t, k, fallback)
  return User.util.get(t, k, function()
    return User.util.rawset(t, k, fallback)
  end, true)
end

local timer = nil ---@type uv.uv_timer_t|nil|?

---@param original lsp.ClientCapabilities
---@param inserts lsp.ClientCapabilities
---@return lsp.ClientCapabilities client_caps
---@overload fun(original: lsp.ClientCapabilities): client_caps: lsp.ClientCapabilities
local function insert_client(original, inserts)
  User.check.validate({
    original = { original, { 'table' } },
    inserts = { inserts, { 'table', 'nil' }, true },
  })

  return vim.tbl_deep_extend('force', original, inserts or {})
end

---@class Lsp.Server
---@field autocmd Lsp.SubMods.Autocmd
---@field kinds Lsp.SubMods.Kinds
local M = {}

setmetatable(M, {
  __index = function(self, k) ---@param self Lsp.Server
    local raw = User.util.get(self, k)
    if raw ~= nil then
      return raw
    end

    if type(k) ~= 'string' then
      return
    end

    ---@cast k string
    if User.check.module('config.lsp.' .. k) then
      return get(self, k, require('config.lsp.' .. k))
    end
  end,
})

local function timer_cb()
  local logfile = vim.lsp.log.get_filename()
  local stat = uv.fs_stat(logfile)
  if stat and stat.size >= 2097152 then
    local fd = assert(uv.fs_open(logfile, 'w', tonumber('644', 8)), 'Unable to open LSP log file')
    assert(uv.fs_ftruncate(fd, 0), 'Unable to truncate LSP log file')
    assert(uv.fs_close(fd), 'Unable to close file descriptor for LSP log file')
    vim.notify('LSP Log has been cleared!', vim.log.levels.INFO)
  end
end

local client_names = {} ---@type string[]

local function make_timer()
  if timer and timer:is_active() then
    return
  end

  timer = assert(uv.new_timer(), 'Unable to create timer')

  local group = vim.api.nvim_create_augroup('lsp_autoclear', { clear = true })
  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = group,
    callback = function()
      if timer and timer:is_active() then
        assert(timer:stop() ~= nil, 'Unable to stop LSP log cleanup timer')
        timer = nil
      end
    end,
  })
  vim.api.nvim_create_autocmd('VimEnter', {
    group = group,
    callback = function()
      if timer and not timer:is_active() then
        assert(timer:start(10000, 900000, vim.schedule_wrap(timer_cb)) ~= nil, 'Unable to start LSP log cleanup timer')
      end
    end,
  })
end

---@param caps lsp.ClientCapabilities
---@return lsp.ClientCapabilities caps
---@overload fun(): caps: lsp.ClientCapabilities
function M.make_capabilities(caps)
  User.check.validate({ caps = { caps, { 'table', 'nil' }, true } })

  caps = caps or {}
  if User.check.module('blink.cmp') then
    caps = vim.tbl_deep_extend(
      'force',
      caps,
      vim.lsp.protocol.make_client_capabilities(),
      require('blink.cmp').get_lsp_capabilities({}, true)
    )
  end

  if User.check.module('lsp-file-operations') then
    caps = vim.tbl_deep_extend('force', caps, require('lsp-file-operations').default_capabilities())
  elseif User.check.module('nvim-file-operations.config') then
    caps = vim.tbl_deep_extend('force', caps, require('nvim-file-operations.config').default_capabilities())
  end
  return caps
end

---@param name string
---@param config vim.lsp.Config
---@return vim.lsp.Config config
function M.populate(name, config)
  config.capabilities = config.capabilities
      and insert_client(config.capabilities, M.make_capabilities(config.capabilities or {}))
    or M.make_capabilities()

  if vim.list_contains({ 'html', 'jsonls' }, name) then
    config.capabilities = insert_client(config.capabilities, {
      textDocument = { completion = { completionItem = { snippetSupport = true } } },
    })
  elseif name == 'rust_analyzer' then
    config.capabilities = insert_client(config.capabilities, {
      experimental = { serverStatusNotification = true },
    })
  elseif name == 'clangd' then
    config.capabilities = insert_client(config.capabilities, {
      offsetEncoding = { 'utf-8', 'utf-16' },
      textDocument = { completion = { editsNearCursor = true } },
    })
  elseif name == 'gh_actions_ls' then
    config.capabilities = insert_client(config.capabilities, {
      workspace = { didChangeWorkspaceFolders = { dynamicRegistration = true } },
    })
  elseif name == 'lua_ls' and User.check.module('lazydev') then
    config.root_dir = function(bufnr, on_dir)
      on_dir(require('lazydev').find_workspace(bufnr))
    end
  end
  return config
end

function M.setup()
  vim.lsp.protocol.TextDocumentSyncKind.Full = 1
  vim.lsp.protocol.TextDocumentSyncKind[1] = 'Full'

  vim.lsp.config('*', { capabilities = M.make_capabilities() })

  vim.diagnostic.config({
    float = true,
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.HINT] = '󰌵',
        [vim.diagnostic.severity.INFO] = '',
        [vim.diagnostic.severity.WARN] = '',
      },
    },
    underline = true,
    virtual_lines = false,
    virtual_text = true,
  })

  vim.lsp.log.set_level(vim.log.levels.ERROR)
  for name, client in pairs(Clients) do
    if client then
      vim.lsp.config(name, M.populate(name, client))
      if not vim.list_contains(client_names, name) then
        table.insert(client_names, name)
      end
    end
  end
  table.sort(client_names)

  make_timer()

  vim.lsp.enable(client_names)

  User.config.keymaps.set({
    n = {
      ['<leader>l'] = { group = '+LSP' },
      ['<leader>lC'] = {
        function()
          vim.notify(vim.inspect(client_names))
        end,
        User.maps.desc('List Clients'),
      },
    },
    v = { ['<leader>l'] = { group = '+LSP' } },
  })

  M.autocmd.setup()
  M.kinds.setup()
end

---@param config vim.lsp.Config
---@param name string
---@param exe string
---@overload fun(config: vim.lsp.Config, name: string)
function M.add(config, name, exe)
  User.check.validate({
    config = { config, { 'table' } },
    name = { name, { 'string' } },
    exe = { exe, { 'string', 'nil' }, true },
  })

  if User.check.executable(exe or name) then
    Clients[name] = M.populate(name, Clients[name] and vim.tbl_deep_extend('force', Clients[name], config) or config)
    M.setup()
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
