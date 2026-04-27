---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/boolean-toggle.nvim',
  dev = true,
  version = false,
  config = function()
    require('boolean-toggle').setup({ auto_write = true, keymaps = { toggle = '<CR>' } })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
