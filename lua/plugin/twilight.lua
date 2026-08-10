---@module 'lazy'
return { ---@type LazySpec
  'folke/twilight.nvim',
  version = false,
  cond = not require('user_api').check.in_console(),
  config = function()
    local Twilight = require('twilight')
    Twilight.setup({
      context = 10,
      dimming = { alpha = 0.4, color = { 'Normal', '#ffffff' }, inactive = true, term_bg = '#000000' },
      exclude = {},
      expand = { 'function', 'method', 'table', 'if_statement' },
      treesitter = true,
    })

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = {
        ['<leader>ut'] = { group = '+Twilight' },
        ['<leader>utd'] = { Twilight.disable, desc('Disable Twilight') },
        ['<leader>ute'] = { Twilight.enable, desc('Enable Twilight') },
        ['<leader>utt'] = { Twilight.toggle, desc('Toggle Twilight') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
