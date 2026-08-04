---@module 'lazy'
return { ---@type LazySpec
  'nvimdev/lspsaga.nvim',
  version = false,
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lspsaga').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
