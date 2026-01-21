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

---@class Lsp.SubMods.Autocmd
local Autocmd = {}

Autocmd.AUKeys = { ---@type AllModeMaps
  n = {
    K = { vim.lsp.buf.hover, desc('Hover') },
    ['<leader>lf'] = { group = '+File Operations' },
    ['<leader>lw'] = { group = '+Workspace' },
    ['<leader>lfD'] = { vim.lsp.buf.declaration, desc('Declaration') },
    ['<leader>lfd'] = { vim.lsp.buf.definition, desc('Definition') },
    ['<leader>lfi'] = { vim.lsp.buf.implementation, desc('Implementation') },
    ['<leader>lfS'] = { vim.lsp.buf.signature_help, desc('Signature Help') },
    ['<leader>lwa'] = { vim.lsp.buf.add_workspace_folder, desc('Add Workspace Folder') },
    ['<leader>lwr'] = { vim.lsp.buf.remove_workspace_folder, desc('Remove Workspace Folder') },
    ['<leader>lfT'] = { vim.lsp.buf.type_definition, desc('Type Definition') },
    ['<leader>lfR'] = { vim.lsp.buf.rename, desc('Rename...') },
    ['<leader>lfr'] = { vim.lsp.buf.references, desc('References') },
    ['<leader>lc'] = { vim.lsp.buf.code_action, desc('Code Action') },
    ['<leader>le'] = { vim.diagnostic.open_float, desc('Open Diagnostics Float') },
    ['<leader>lq'] = { vim.diagnostic.setloclist, desc('Set Loclist') },
    ['<leader>lwl'] = { print_workspace_folders, desc('List Workspace Folders') },
    ['<leader>lff'] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      desc('Format File'),
    },
  },
  v = { ['<leader>lc'] = { vim.lsp.buf.code_action, desc('LSP Code Action') } },
}

---@type AuRepeat
Autocmd.autocommands = {
  LspAttach = {
    {
      group = vim.api.nvim_create_augroup('UserLsp', { clear = false }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          return
        end

        require('user_api.config').keymaps(Autocmd.AUKeys)
        require('user_api.config').keymaps(
          vim.tbl_deep_extend('keep', Autocmd.AUKeys, {
            n = {
              ['<leader>lS'] = { group = '+Server', buffer = args.buf },
              ['<leader>lSr'] = {
                function()
                  _G.LAST_LSP = vim.deepcopy(client.config)
                  vim.lsp.enable(client.name, false)
                  vim.schedule(function()
                    vim.lsp.enable(_G.LAST_LSP.name, true)
                  end)
                end,
                desc('Server Restart'),
              },
              ['<leader>lSs'] = {
                function()
                  _G.LAST_LSP = vim.deepcopy(client.config)
                  vim.lsp.enable(_G.LAST_LSP.name, false)
                end,
                desc('Server Stop'),
              },
              ['<leader>lSi'] = {
                function()
                  local config = vim.deepcopy(client.config)
                  table.sort(config)
                  vim.notify(('%s: %s'):format(client.name, vim.inspect(config)), INFO)
                end,
                desc('Show LSP Info'),
              },
            },
          }),
          args.buf
        )
      end,
    },
  },
  LspProgress = {
    {
      group = vim.api.nvim_create_augroup('UserLsp', { clear = false }),
      callback = function()
        vim.cmd.redrawstatus()
      end,
    },
  },
}

---@return Lsp.SubMods.Autocmd|fun(override?: AuRepeat|nil)
function Autocmd.new()
  return setmetatable({}, {
    __index = Autocmd,
    ---@param self Lsp.SubMods.Autocmd
    ---@param override? AuRepeat
    __call = function(self, override)
      require('user_api.check.exists').validate({
        override = { override, { 'table', 'nil' }, true },
      })

      self.autocommands = vim.tbl_deep_extend('keep', override or {}, self.autocommands)
      require('user_api.util.autocmd').au_repeated(self.autocommands)
    end,
  })
end

return Autocmd.new()
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
