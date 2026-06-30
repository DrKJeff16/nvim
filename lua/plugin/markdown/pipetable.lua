---@module 'lazy'
return { ---@type LazySpec
  'dominic-righthere/markdown-pipetable.nvim',
  dev = true,
  ft = 'markdown',
  config = function()
    require('pipetable').setup({})
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
