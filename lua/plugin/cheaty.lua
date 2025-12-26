---@module 'lazy'
return { ---@type LazySpec
  'StikyPiston/cheaty.nvim',
  dev = true,
  version = false,
  config = function()
    require('cheaty').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
