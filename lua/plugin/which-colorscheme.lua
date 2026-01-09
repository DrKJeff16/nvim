---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/which-colorscheme.nvim',
  event = 'VeryLazy',
  dev = true,
  version = false,
  config = function()
    require('which-colorscheme').setup({
      prefix = '<leader>uc',
      group = 'Colorschemes',
      random = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
