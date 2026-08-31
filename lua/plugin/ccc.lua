---@module 'lazy'
return { ---@type LazySpec
  'uga-rosa/ccc.nvim',
  event = 'VeryLazy',
  version = false,
  cond = vim.o.termguicolors,
  config = function()
    require('ccc').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
