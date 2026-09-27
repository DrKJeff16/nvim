---@module 'lazy'
return { ---@type LazySpec
  'justinhj/battery.nvim',
  lazy = true,
  version = false,
  config = function()
    require('battery').setup({
      multiple_battery_selection = 1,
      show_percent = true,
      show_plugged_icon = true,
      show_status_when_no_battery = false,
      show_unplugged_icon = true,
      update_rate_seconds = 10,
      vertical_icons = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
