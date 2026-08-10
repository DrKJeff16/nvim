---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/which-colorscheme.nvim',
  dev = true,
  version = false,
  event = 'VeryLazy',
  config = function()
    require('which-colorscheme').setup({
      custom_groups = {
        A = { 'tokyonight', 'tokyodark', 'catppuccin', 'kanagawa', 'nightfox', 'carbonfox', 'onedark', 'minicyan' },
      },
      custom_only = false,
      excluded = {
        'blue',
        'catppuccin-latte',
        'darkblue',
        'dawnfox',
        'dayfox',
        'gruvdark-light',
        'kanagawa-lotus',
        'teide-light',
        'tokyonight-day',
      },
      group_name = 'Colorschemes',
      grouping = { random = true, uppercase_groups = true, labels = { A = 'Favourites', B = 'Extra' } },
      prefix = '<leader>uc',
    })

    require('user_api').config.keymaps.set({ n = { ['<leader>u'] = { group = '+UI' } } })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
