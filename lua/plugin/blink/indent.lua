---@module 'lazy'
return { ---@type LazySpec
  'saghen/blink.indent',
  version = false,
  cond = not require('user_api.check').in_console(),
  opts = {},
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
