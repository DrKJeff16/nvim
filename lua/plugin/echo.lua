---@module 'lazy'
return { ---@type LazySpec
  'melmass/echo.nvim',
  version = false,
  cond = not require('user_api.check').in_console(),
  opts = { demo = true },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
