---@module 'lazy'
return { ---@type LazySpec
  'nvim-telescope/telescope.nvim',
  version = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-lua/plenary.nvim',
    'debugloop/telescope-undo.nvim',
    'OliverChao/telescope-picker-list.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'crispgm/telescope-heading.nvim',
    'tpope/vim-fugitive',
    { 'polirritmico/telescope-lazy-plugins.nvim', dev = true },
  },
  config = require('config.util').require('plugin.telescope'),
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
