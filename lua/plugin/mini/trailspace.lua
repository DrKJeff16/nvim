---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.trailspace',
  version = false,
  config = function()
    require('mini.trailspace').setup({ only_in_normal_buffers = true })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
