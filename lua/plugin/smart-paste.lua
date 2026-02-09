---@module 'lazy'
return { ---@type LazySpec
  'nemanjamalesija/smart-paste.nvim',
  event = 'VeryLazy',
  version = false,
  config = function()
    require('smart-paste').setup({
      keys = { 'p', 'P', 'gp', 'gP' },
      exclude_filetypes = {},
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
