---@module 'lazy'
return { ---@type LazySpec
  'folke/styler.nvim',
  event = 'VeryLazy',
  version = false,
  config = function()
    require('styler').setup({
      themes = { help = { colorscheme = 'catppuccin-mocha' }, markdown = { colorscheme = 'tokyodark' } },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
