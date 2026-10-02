---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.pick',
  version = false,
  config = function()
    require('mini.pick').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
