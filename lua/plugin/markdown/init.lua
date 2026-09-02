---@module 'lazy'
return { ---@type LazySpec
  'StefanBartl/markdown.nvim',
  version = false,
  dependencies = { 'StefanBartl/lib.nvim', 'StefanBartl/hover.nvim' },
  cmd = { 'Markdown' },
  ft = { 'markdown', 'mdx', 'md' },
  config = function()
    require('markdown').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
