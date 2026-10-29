local INFO = vim.log.levels.INFO
local User = require('user_api')

local function print_workspace_folders()
  local msg = ''
  for _, v in ipairs(vim.lsp.buf.list_workspace_folders()) do
    msg = ('%s\n - %s'):format(msg, v)
  end
  vim.notify(msg, INFO, { title = 'LSP', animate = true, hide_from_history = false, timeout = 5000 })
end

---@return vim.lsp.Client|nil client
local function get_client()
  local client = vim.lsp.get_clients({ buf = vim.api.nvim_get_current_buf() })
  if client and not vim.tbl_isempty(client) then
    return client
  end
end

local function async_fmt()
  vim.lsp.buf.format({ async = true })
end

local function server_stop()
  local client = get_client()
  if not client then
    return
  end

  _G.LAST_LSP = vim.deepcopy(client[1].config)
  vim.lsp.enable(client[1].name, false)
end

local function server_restart()
  if get_client() then
    server_stop()
    vim.schedule(function()
      vim.lsp.enable(_G.LAST_LSP.name, true)
    end)
  end
end

local function server_start()
  local client = get_client()
  if not client or client[1].initialized then
    return
  end

  _G.LAST_LSP = vim.deepcopy(client[1].config)
  vim.schedule(function()
    vim.lsp.enable(_G.LAST_LSP.name, true)
  end)
end

local function server_info()
  local client = get_client()
  if client then
    local config = vim.deepcopy(client[1].config)
    config.capabilities = nil

    table.sort(config)
    vim.notify(vim.inspect(config))
  end
end

---@class Lsp.SubMods.Autocmd
local M = {}

local Keys = { ---@type AllModeMaps
  n = {
    ['<leader>lS'] = { group = '+Server' },
    ['<leader>lf'] = { group = '+File Operations' },
    ['<leader>lw'] = { group = '+Workspace' },
    ['<leader>lSS'] = { server_start, User.maps.desc('Server Stop') },
    ['<leader>lSi'] = { server_info, User.maps.desc('Show LSP Info') },
    ['<leader>lSr'] = { server_restart, User.maps.desc('Server Restart') },
    ['<leader>lSs'] = { server_stop, User.maps.desc('Server Start') },
    ['<leader>lc'] = { vim.lsp.buf.code_action, User.maps.desc('Code Action') },
    ['<leader>le'] = { vim.diagnostic.open_float, User.maps.desc('Open Diagnostics Float') },
    ['<leader>lfD'] = { vim.lsp.buf.declaration, User.maps.desc('Declaration') },
    ['<leader>lfR'] = { vim.lsp.buf.rename, User.maps.desc('Rename...') },
    ['<leader>lfS'] = { vim.lsp.buf.signature_help, User.maps.desc('Signature Help') },
    ['<leader>lfT'] = { vim.lsp.buf.type_definition, User.maps.desc('Type Definition') },
    ['<leader>lfd'] = { vim.lsp.buf.definition, User.maps.desc('Definition') },
    ['<leader>lff'] = { async_fmt, User.maps.desc('Format File') },
    ['<leader>lfi'] = { vim.lsp.buf.implementation, User.maps.desc('Implementation') },
    ['<leader>lfr'] = { vim.lsp.buf.references, User.maps.desc('References') },
    ['<leader>lq'] = { vim.diagnostic.setloclist, User.maps.desc('Set Loclist') },
    ['<leader>lwa'] = { vim.lsp.buf.add_workspace_folder, User.maps.desc('Add Workspace Folder') },
    ['<leader>lwl'] = { print_workspace_folders, User.maps.desc('List Workspace Folders') },
    ['<leader>lwr'] = { vim.lsp.buf.remove_workspace_folder, User.maps.desc('Remove Workspace Folder') },
  },
  v = { ['<leader>lc'] = { vim.lsp.buf.code_action, User.maps.desc('LSP Code Action') } },
}

local autocommands = { ---@type AuRepeat
  LspAttach = {
    {
      group = vim.api.nvim_create_augroup('UserLsp', { clear = false }),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
          return
        end

        if client:supports_method('textDocument/hover', ev.buf) then
          User.config.keymaps.set(
            { n = { K = { vim.lsp.buf.hover, User.maps.desc('Hover', { buf = ev.buf }) } } },
            { bufnr = ev.buf }
          )
        end
      end,
    },
  },
  LspProgress = {
    {
      group = vim.api.nvim_create_augroup('UserLsp', { clear = false }),
      pattern = '*',
      callback = function()
        vim.cmd.redrawstatus()
      end,
    },
  },
}

---@param override AuRepeat
---@overload fun()
function M.setup(override)
  User.check.validate({ override = { override, { 'table', 'nil' }, true } })

  autocommands = vim.tbl_deep_extend('keep', override or {}, autocommands)
  User.util.autocmd.au_repeated(autocommands)
  User.config.keymaps.set(Keys)
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
