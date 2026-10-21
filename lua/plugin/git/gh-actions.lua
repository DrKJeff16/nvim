---@module 'lazy'
return { ---@type LazySpec
  'Hdoc1509/gh-actions.nvim',
  ft = 'yaml',
  version = false,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cond = require('user_api').check.executable('tree-sitter'),
  config = function()
    require('gh-actions.tree-sitter').setup()
    require('nvim-treesitter').install({ 'gh_actions_expressions' })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
