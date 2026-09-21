---@module 'vim.lsp._meta'

local Clients = require('config.lsp.servers')
local uv = vim.uv or vim.loop

local timer = nil ---@type uv.uv_timer_t|nil|?

---@param original lsp.ClientCapabilities
---@param inserts? lsp.ClientCapabilities
---@return lsp.ClientCapabilities client_caps
local function insert_client(original, inserts)
  return vim.tbl_deep_extend('force', original, inserts or {})
end

---@class Lsp.Server
---@field autocmd Lsp.SubMods.Autocmd
---@field kinds Lsp.SubMods.Kinds
local Server = {}

local function timer_cb()
  local logfile = vim.lsp.log.get_filename()
  local stat = uv.fs_stat(logfile)
  if stat and stat.size >= 2097152 then
    local fd = uv.fs_open(logfile, 'w', tonumber('644', 8))
    if fd then
      uv.fs_ftruncate(fd, 0)
      uv.fs_close(fd)

      vim.notify('LSP Log has been cleared!', vim.log.levels.INFO)
    end
  end
end

local client_names = {} ---@type string[]

local function make_timer()
  if timer and timer:is_active() then
    return
  end

  timer = uv.new_timer()
  if timer then
    local group = vim.api.nvim_create_augroup('lsp_autoclear', { clear = true })
    vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
      group = group,
      callback = function()
        if timer and timer:is_active() then
          timer:stop()
          timer = nil
        end
      end,
    })
    vim.api.nvim_create_autocmd('VimEnter', {
      group = group,
      callback = function()
        if timer and not timer:is_active() then
          timer:start(10000, 900000, vim.schedule_wrap(timer_cb))
        end
      end,
    })
  end
end

---@param old_caps? lsp.ClientCapabilities
---@return lsp.ClientCapabilities caps
function Server.make_capabilities(old_caps)
  local caps = old_caps or {}
  if require('user_api').check.module('blink.cmp') then
    caps = vim.tbl_deep_extend(
      'force',
      caps,
      vim.lsp.protocol.make_client_capabilities(),
      require('blink.cmp').get_lsp_capabilities({}, true)
    )
  end
  if require('user_api').check.module('lsp-file-operations') then
    caps = vim.tbl_deep_extend('force', caps, require('lsp-file-operations').default_capabilities())
  elseif require('user_api').check.module('nvim-file-operations.config') then
    caps = vim.tbl_deep_extend('force', caps, require('nvim-file-operations.config').default_capabilities())
  end
  return caps
end

---@param name string
---@param config vim.lsp.Config
---@return vim.lsp.Config config
function Server.populate(name, config)
  config.capabilities = config.capabilities
      and insert_client(config.capabilities, Server.make_capabilities(config.capabilities or {}))
    or Server.make_capabilities()

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
  elseif name == 'lua_ls' and require('user_api').check.module('lazydev') then
    config.root_dir = function(bufnr, on_dir)
      on_dir(require('lazydev').find_workspace(bufnr))
    end
  elseif require('user_api').check.module('schemastore') and name == 'jsonls' then
    config.settings = insert_client(config.settings or {}, {
      json = { validate = { enable = true }, schemas = require('schemastore').json.schemas() },
    })
  elseif require('user_api').check.module('schemastore') and name == 'yamlls' then
    config.settings = insert_client(config.settings or {}, {
      yaml = { schemaStore = { enable = false, url = '' }, schemas = require('schemastore').yaml.schemas() },
    })
  end
  return config
end

function Server.setup()
  vim.lsp.protocol.TextDocumentSyncKind.Full = 1
  vim.lsp.protocol.TextDocumentSyncKind[1] = 'Full'

  vim.lsp.config('*', { capabilities = Server.make_capabilities() })

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
      vim.lsp.config(name, Server.populate(name, client))
      if not vim.list_contains(client_names, name) then
        table.insert(client_names, name)
      end
    end
  end
  table.sort(client_names)

  make_timer()

  vim.lsp.enable(client_names)

  local desc = require('user_api').maps.desc
  require('user_api').config.keymaps.set({
    n = {
      ['<leader>l'] = { group = '+LSP' },
      ['<leader>lC'] = {
        function()
          vim.notify(vim.inspect(client_names))
        end,
        desc('List Clients'),
      },
    },
    v = { ['<leader>l'] = { group = '+LSP' } },
  })

  require('config.lsp.autocmd').setup()
  require('config.lsp.kinds').setup()
end

---@param config vim.lsp.Config
---@param name string
---@param exe? string
function Server.add(config, name, exe)
  require('user_api').check.validate({
    config = { config, { 'table' } },
    name = { name, { 'string' } },
    exe = { exe, { 'string', 'nil' }, true },
  })

  if require('user_api').check.executable(exe or name) then
    Clients[name] =
      Server.populate(name, Clients[name] and vim.tbl_deep_extend('force', Clients[name], config) or config)
    Server.setup()
  end
end

local M = setmetatable(Server, { ---@type Lsp.Server
  __index = function(self, k)
    local raw = rawget(self, k) or nil
    if raw then
      return raw
    end

    if require('user_api').check.module('config.lsp.' .. k) then
      return require('user_api').util.rawset(self, k, require('config.lsp.' .. k))
    end
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
