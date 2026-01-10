---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/which-colorscheme.nvim',
  event = 'VeryLazy',
  dev = true,
  version = false,
  config = function()
    require('which-colorscheme').setup({
      prefix = '<leader>uc',
      group_name = 'Colorschemes',
      custom_groups = {
        A = {
          'tokyonight',
          'tokyonight-storm',
          'tokyonight-moon',
          'tokyonight-night',
          'tokyonight-day',
        },
        B = { 'onedark', 'catppuccin' },
      },
      grouping = {
        random = true,
        uppercase_groups = true,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
