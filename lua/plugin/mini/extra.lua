---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.extra',
  version = false,
  config = function()
    require('mini.extra').setup({})
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
