---@alias ClientCaps lsp.ClientCapabilities|table<string, boolean|string|number|unknown[]|vim.NIL>

local ERROR = vim.diagnostic.severity.ERROR
local WARN = vim.diagnostic.severity.WARN
local INFO = vim.diagnostic.severity.INFO
local HINT = vim.diagnostic.severity.HINT
local mk_caps = vim.lsp.protocol.make_client_capabilities
local uv = vim.uv or vim.loop

local function timer_cb()
  local logfile = vim.lsp.log.get_filename()
  local stat = uv.fs_stat(logfile)
  if not stat or stat.size < 2097152 then
    return
  end

  local fd = uv.fs_open(logfile, 'w', tonumber('644', 8))
  if not fd then
    return
  end

  uv.fs_ftruncate(fd, 0)
  uv.fs_close(fd)

  vim.notify('LSP Log has been cleared!', vim.log.levels.INFO)
end

---@param original ClientCaps
---@param inserts ClientCaps
---@return ClientCaps client_caps
---@overload fun(original: ClientCaps): client_caps: ClientCaps
local function insert_client(original, inserts)
  return vim.tbl_deep_extend('keep', inserts or {}, original)
end

---@class Lsp.Server
local Server = {}

Server.client_names = {} ---@type string[]
Server.Clients = require('config.lsp.servers')

function Server.make_timer()
  if Server.timer and Server.timer:is_active() then
    return
  end

  Server.timer = uv.new_timer()
  if not Server.timer then
    return
  end

  local group = vim.api.nvim_create_augroup('lsp_autoclear', { clear = true })
  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = group,
    callback = function()
      if not Server.timer then
        return
      end
      if not Server.timer:is_active() then
        return
      end

      Server.timer:stop()
    end,
  })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = group,
    callback = function()
      if Server.timer and Server.timer:is_active() then
        return
      end
      if not Server.timer then
        return
      end

      Server.timer:start(10000, 900000, vim.schedule_wrap(timer_cb))
    end,
  })
end

---@param old_caps lsp.ClientCapabilities
---@return lsp.ClientCapabilities caps
---@overload fun(): caps: lsp.ClientCapabilities
function Server.make_capabilities(old_caps)
  return vim.tbl_deep_extend(
    'keep',
    old_caps or {},
    require('blink.cmp').get_lsp_capabilities({}, true),
    mk_caps()
  )
end

---@param name string
---@param config vim.lsp.Config
---@return vim.lsp.Config config
function Server.populate(name, config)
  if require('user_api.check.value').type_not_empty('table', config.capabilities) then
    config.capabilities =
      insert_client(config.capabilities, Server.make_capabilities(config.capabilities or {}))
  else
    config.capabilities = Server.make_capabilities()
  end

  if vim.list_contains({ 'html', 'jsonls' }, name) then
    config.capabilities = insert_client(config.capabilities, {
      textDocument = { completion = { completionItem = { snippetSupport = true } } },
    })
    return config
  end

  if name == 'rust_analyzer' then
    config.capabilities = insert_client(config.capabilities, {
      experimental = { serverStatusNotification = true },
    })
    return config
  end
  if name == 'clangd' then
    config.capabilities = insert_client(config.capabilities, {
      offsetEncoding = { 'utf-8', 'utf-16' },
      textDocument = { completion = { editsNearCursor = true } },
    })
    return config
  end
  if name == 'gh_actions_ls' then
    config.capabilities = insert_client(config.capabilities, {
      workspace = { didChangeWorkspaceFolders = { dynamicRegistration = true } },
    })
    return config
  end

  local exists = require('user_api.check.exists').module
  if name == 'lua_ls' and exists('lazydev') then
    config.root_dir = function(bufnr, on_dir)
      on_dir(require('lazydev').find_workspace(bufnr))
    end
    return config
  end
  if exists('schemastore') then
    local SS = require('schemastore')
    if name == 'jsonls' then
      config.settings = insert_client(config.settings or {}, {
        json = { validate = { enable = true }, schemas = SS.json.schemas() },
      })
    end
    if name == 'yamlls' then
      config.settings = insert_client(config.settings or {}, {
        yaml = { schemaStore = { enable = false, url = '' }, schemas = SS.yaml.schemas() },
      })
    end
  end
  return config
end

function Server.setup()
  vim.lsp.protocol.TextDocumentSyncKind.Full = 1
  vim.lsp.protocol.TextDocumentSyncKind[1] = 'Full'
  vim.lsp.config('*', {
    capabilities = Server.make_capabilities(),
  })
  vim.diagnostic.config({
    signs = { text = { [ERROR] = '', [WARN] = '', [INFO] = '', [HINT] = '󰌵' } },
    float = true,
    underline = true,
    virtual_lines = false,
    virtual_text = true,
    severity_sort = false,
  })

  vim.lsp.log.set_level(vim.log.levels.ERROR)
  for name, client in pairs(Server.Clients) do
    if client then
      vim.lsp.config(name, Server.populate(name, client))
      if not vim.list_contains(Server.client_names, name) then
        table.insert(Server.client_names, name)
      end
    end
  end
  table.sort(Server.client_names)

  Server.make_timer()

  vim.lsp.enable(Server.client_names)

  local desc = require('user_api.maps').desc
  require('user_api.config').keymaps.set({
    n = {
      ['<leader>l'] = { group = '+LSP' },
      ['<leader>lC'] = {
        function()
          vim.notify(vim.inspect(Server.client_names))
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
---@param exe string
---@overload fun(config: vim.lsp.Config, name: string)
function Server.add(config, name, exe)
  require('user_api.check').validate({
    config = { config, { 'table' } },
    name = { name, { 'string' } },
    exe = { exe, { 'string', 'nil' }, true },
  })
  exe = (exe and exe ~= '') and exe or name

  if not require('user_api.check.exists').executable(exe) then
    return
  end

  local cfg = Server.Clients[name]

  Server.Clients[name] = cfg and vim.tbl_deep_extend('force', cfg, config) or config
  Server.Clients[name] = Server.populate(name, vim.deepcopy(Server.Clients[name]))
  Server.setup()
end

return Server
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
