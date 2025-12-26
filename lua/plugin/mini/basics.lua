---@module 'lazy'

return { ---@type LazySpec
  'nvim-mini/mini.basics',
  version = false,
  config = function()
    require('mini.basics').setup({
      options = { basic = true, extra_ui = true, win_borders = 'rounded' },
      autocommands = { basic = true, relnum_in_visual_mode = false },
      silent = true,
      mappings = {
        basic = false,
        option_toggle_prefix = '',
        windows = true,
        move_with_alt = false,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
