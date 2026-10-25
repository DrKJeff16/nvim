---@module 'lazy'
return { ---@type LazySpec
  'username/plugin',
  dev = true,
  version = false,
  config = function()
    require('foo').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
