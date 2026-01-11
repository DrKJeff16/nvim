---@module 'lazy'
return { ---@type LazySpec
  'stephansama/fzf-nerdfont.nvim',
  dev = true,
  cmd = 'FzfNerdfont',
  build = ':FzfNerdfont generate',
  version = false,
  dependencies = { 'ibhagwan/fzf-lua' },
  opts = {},
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
