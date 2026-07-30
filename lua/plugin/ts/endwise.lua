---@module 'lazy'
return { ---@type LazySpec
  'RRethy/nvim-treesitter-endwise',
  version = false,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cond = require('user_api').check.executable('tree-sitter'),
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
