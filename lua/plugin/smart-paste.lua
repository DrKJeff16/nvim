---@module 'lazy'
return { ---@type LazySpec
  'nemanjamalesija/smart-paste.nvim',
  dev = true,
  event = 'VeryLazy',
  version = false,
  config = function()
    require('smart-paste').setup({ exclude_filetypes = {}, keys = { 'p', 'P', 'gp', 'gP' } })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
