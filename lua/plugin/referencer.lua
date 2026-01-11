---@module 'lazy'
return { ---@type LazySpec
  'romus204/referencer.nvim',
  version = false,
  cond = false,
  config = function()
    require('referencer').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
