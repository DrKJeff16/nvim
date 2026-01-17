local mk_caps = vim.lsp.protocol.make_client_capabilities

---@param original lsp.ClientCapabilities|table<string, boolean|string|number|unknown[]|vim.NIL>
---@param inserts? lsp.ClientCapabilities|table<string, boolean|string|number|unknown[]|vim.NIL>
---@return lsp.ClientCapabilities|table<string, boolean|string|number|unknown[]|vim.NIL>
local function insert_client(original, inserts)
  return vim.tbl_deep_extend('keep', inserts or {}, original)
end

---@class Lsp.Server
local Server = {}

Server.client_names = {} ---@type string[]
Server.Clients = require('plugin.lsp.servers')

---@param T lsp.ClientCapabilities|nil
---@return lsp.ClientCapabilities caps
---@overload fun(): caps: lsp.ClientCapabilities
function Server.make_capabilities(T)
  return vim.tbl_deep_extend(
    'keep',
    T or {},
    require('blink.cmp').get_lsp_capabilities({}, true),
    mk_caps()
  )
end

---@param name string
---@param config vim.lsp.Config
---@return vim.lsp.Config config
function Server.populate(name, config)
  if require('user_api.check.value').type_not_empty('table', config.capabilities) then
    local old_caps = vim.deepcopy(config.capabilities)
    local caps = Server.make_capabilities(old_caps)
    config.capabilities = insert_client(vim.deepcopy(config.capabilities), caps)
  else
    config.capabilities = Server.make_capabilities()
  end

  if vim.list_contains({ 'html', 'jsonls' }, name) then
    config.capabilities = insert_client(vim.deepcopy(config.capabilities), {
      textDocument = { completion = { completionItem = { snippetSupport = true } } },
    })
    return config
  end

  if name == 'rust_analyzer' then
    config.capabilities = insert_client(vim.deepcopy(config.capabilities), {
      experimental = { serverStatusNotification = true },
    })
    return config
  end
  if name == 'clangd' then
    config.capabilities = insert_client(vim.deepcopy(config.capabilities), {
      offsetEncoding = { 'utf-8', 'utf-16' },
      textDocument = { completion = { editsNearCursor = true } },
    })
    return config
  end
  if name == 'gh_actions_ls' then
    config.capabilities = insert_client(vim.deepcopy(config.capabilities), {
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
    if name == 'jsonls' then
      if not config.settings then
        config.settings = {}
      end
      config.settings = insert_client(vim.deepcopy(config.settings), {
        json = {
          validate = { enable = true },
          schemas = require('schemastore').json.schemas(),
        },
      })
    end
    if name == 'yamlls' then
      if not config.settings then
        config.settings = {}
      end
      config.settings = insert_client(vim.deepcopy(config.settings), {
        yaml = {
          schemaStore = { enable = false, url = '' },
          schemas = require('schemastore').yaml.schemas(),
        },
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
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.INFO] = '',
        [vim.diagnostic.severity.HINT] = '󰌵',
      },
    },
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

  vim.lsp.enable(Server.client_names)

  local desc = require('user_api.maps').desc
  require('user_api.config').keymaps({
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

  local Autocmd = require('plugin.lsp.autocmd')
  Autocmd()

  local Kinds = require('plugin.lsp.kinds')
  Kinds()

  local Trouble = require('plugin.lsp.trouble')
  Trouble()
end

---@param config vim.lsp.Config
---@param name string
---@param exe string|nil
---@overload fun(config: vim.lsp.Config, name: string)
function Server.add(config, name, exe)
  exe = require('user_api.check.value').type_not_empty('string', exe) and exe or name
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
