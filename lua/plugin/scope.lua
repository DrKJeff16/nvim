---@module 'lazy'
return { ---@type LazySpec
  'tiagovla/scope.nvim',
  version = false,
  init = function()
    vim.o.sessionoptions = 'buffers,tabpages,globals'
  end,
  config = function()
    require('scope').setup({
      hooks = {
        pre_tab_leave = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabLeavePre' })
        end,
        post_tab_enter = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabEnterPost' })
        end,
      },
    })

    if require('user_api.check.exists').module('telescope') then
      require('telescope').load_extension('scope')

      local desc = require('user_api.maps').desc
      require('user_api.config').keymaps({
        n = {
          ['<leader>S'] = { group = '+Scope' },
          ['<leader>Sb'] = { '<CMD>Telescope scope buffers<CR>', desc('Scope Buffers (Telescope)') },
          ['<leader><C-t>eS'] = { '<CMD>Telescope scope buffers<CR>', desc('Scope Buffers Picker') },
        },
      })
    end
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
