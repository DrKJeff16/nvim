---@module 'lazy'
return { ---@type LazySpec
  'StefanBartl/mdview.nvim',
  version = false,
  dependencies = { 'StefanBartl/lib.nvim' },
  ft = 'markdown',
  cmd = 'MDView',
  config = function()
    require('mdview').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
