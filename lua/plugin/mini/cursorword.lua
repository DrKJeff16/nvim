---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.cursorword',
  version = false,
  config = function()
    require('mini.cursorword').setup({ delay = 500 })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
