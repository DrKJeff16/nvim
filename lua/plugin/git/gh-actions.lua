---@module 'lazy'
return { ---@type LazySpec
  'Hdoc1509/gh-actions.nvim',
  event = 'VeryLazy',
  version = false,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('gh-actions.tree-sitter').setup()
    require('nvim-treesitter').install({ 'gh_actions_expressions' })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
