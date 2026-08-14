---@module 'lazy'
return { ---@type LazySpec
  'niuiic/todo.nvim',
  dev = true,
  event = 'VeryLazy',
  version = false,
  dependencies = { 'niuiic/core.nvim' },
  cond = require('user_api').check.executable('rg'),
  config = function()
    require('todo').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
