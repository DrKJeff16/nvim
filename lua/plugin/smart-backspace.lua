---@module 'lazy'
return { ---@type LazySpec
  'qwavies/smart-backspace.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = false,
  opts = { disabled_filetypes = { 'py', 'hs', 'md', 'txt' }, enabled = true, silent = true },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
