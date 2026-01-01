---@module 'lazy'
return { ---@type LazySpec
  'wsdjeg/scrollbar.nvim',
  version = false,
  cond = not require('user_api.check').in_console(),
  config = function()
    require('scrollbar').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
