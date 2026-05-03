---@module 'lazy'
return { ---@type LazySpec
  'ankushbhagats/match.nvim',
  dev = true,
  version = false,
  config = function()
    require('match').setup({})
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
