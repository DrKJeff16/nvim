---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.input',
  version = false,
  config = function()
    require('mini.input').setup({ scope = 'editor' })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
