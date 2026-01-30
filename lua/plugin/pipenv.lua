---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/pipenv.nvim',
  dev = true,
  version = false,
  config = function()
    require('pipenv').setup({ output = { height = 0.75, width = 0.85 } })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
