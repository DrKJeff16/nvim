---@module 'lazy'
return { ---@type LazySpec
  'winter-again/wezterm-config.nvim',
  dev = true,
  version = false,
  config = function()
    require('wezterm-config').setup({ append_wezterm_to_rtp = false })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
