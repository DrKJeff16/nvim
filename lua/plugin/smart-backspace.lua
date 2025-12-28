---@module 'lazy'
return { ---@type LazySpec
  'qwavies/smart-backspace.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = false,
  opts = { enabled = true, silent = true, disabled_filetypes = { 'py', 'hs', 'md', 'txt' } },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
