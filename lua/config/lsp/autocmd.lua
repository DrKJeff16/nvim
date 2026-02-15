local INFO = vim.log.levels.INFO
local desc = require('user_api.maps').desc

local function print_workspace_folders()
  local msg = ''
  for _, v in ipairs(vim.lsp.buf.list_workspace_folders()) do
    msg = ('%s\n - %s'):format(msg, v)
  end
  vim.notify(msg, INFO, {
    title = 'LSP',
    animate = true,
    hide_from_history = false,
    timeout = 5000,
  })
end

---@return vim.lsp.Client|nil client
local function get_client()
  local client = vim.lsp.get_clients({ buf = vim.api.nvim_get_current_buf() })
  if not client or vim.tbl_isempty(client) then
    return
  end
  return client
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
  local client = get_client()
  if not client then
    return
  end

  server_stop()
  vim.schedule(function()
    vim.lsp.enable(_G.LAST_LSP.name, true)
  end)
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
  if not client then
    return
  end

  local config = vim.deepcopy(client[1].config)
  config.capabilities = nil

  table.sort(config)
  vim.print(config)
end

---@class Lsp.SubMods.Autocmd
local Autocmd = {}

Autocmd.AUKeys = { ---@type AllModeMaps
  n = {
    K = { vim.lsp.buf.hover, desc('Hover') },
    ['<leader>lS'] = { group = '+Server' },
    ['<leader>lf'] = { group = '+File Operations' },
    ['<leader>lSS'] = { server_start, desc('Server Stop') },
    ['<leader>lSi'] = { server_info, desc('Show LSP Info') },
    ['<leader>lSr'] = { server_restart, desc('Server Restart') },
    ['<leader>lSs'] = { server_stop, desc('Server Start') },
    ['<leader>lc'] = { vim.lsp.buf.code_action, desc('Code Action') },
    ['<leader>le'] = { vim.diagnostic.open_float, desc('Open Diagnostics Float') },
    ['<leader>lfD'] = { vim.lsp.buf.declaration, desc('Declaration') },
    ['<leader>lfR'] = { vim.lsp.buf.rename, desc('Rename...') },
    ['<leader>lfS'] = { vim.lsp.buf.signature_help, desc('Signature Help') },
    ['<leader>lfT'] = { vim.lsp.buf.type_definition, desc('Type Definition') },
    ['<leader>lfd'] = { vim.lsp.buf.definition, desc('Definition') },
    ['<leader>lff'] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      desc('Format File'),
    },
    ['<leader>lfi'] = { vim.lsp.buf.implementation, desc('Implementation') },
    ['<leader>lfr'] = { vim.lsp.buf.references, desc('References') },
    ['<leader>lq'] = { vim.diagnostic.setloclist, desc('Set Loclist') },
    ['<leader>lw'] = { group = '+Workspace' },
    ['<leader>lwa'] = { vim.lsp.buf.add_workspace_folder, desc('Add Workspace Folder') },
    ['<leader>lwl'] = { print_workspace_folders, desc('List Workspace Folders') },
    ['<leader>lwr'] = { vim.lsp.buf.remove_workspace_folder, desc('Remove Workspace Folder') },
  },
  v = { ['<leader>lc'] = { vim.lsp.buf.code_action, desc('LSP Code Action') } },
}

---@type AuRepeat
Autocmd.autocommands = {
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

---@param override? AuRepeat
function Autocmd.setup(override)
  require('user_api.check').validate({
    override = { override, { 'table', 'nil' }, true },
  })

  Autocmd.autocommands = vim.tbl_deep_extend('keep', override or {}, Autocmd.autocommands)
  require('user_api.util.autocmd').au_repeated(Autocmd.autocommands)

  require('user_api.config.keymaps').set(Autocmd.AUKeys)
end

return Autocmd
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
