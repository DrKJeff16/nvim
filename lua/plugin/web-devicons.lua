---@module 'lazy'
return { ---@type LazySpec
  'nvim-tree/nvim-web-devicons',
  version = false,
  config = function()
    require('nvim-web-devicons').setup({
      color_icons = true,
      default_icons = true,
      override = {},
      override_by_extension = {},
      override_by_filename = { ['.gitignore'] = { color = '#f1502f', icon = '', name = 'Gitignore' } },
      override_by_operating_system = {},
      strict = true,
      variant = 'dark',
    })
    require('nvim-web-devicons').set_up_highlights()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
