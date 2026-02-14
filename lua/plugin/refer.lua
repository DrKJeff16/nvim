---@module 'lazy'
return { ---@type LazySpec
  'juniorsundar/refer.nvim',
  version = false,
  dependencies = { 'saghen/blink.cmp', 'nvim-mini/mini.fuzzy' },
  config = function()
    require('refer').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
