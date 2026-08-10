---@module 'lazy'
return { ---@type LazySpec
  'fei6409/log-highlight.nvim',
  version = false,
  opts = {
    extension = 'log',
    filename = { 'syslog' },
    keyword = {
      debug = {},
      error = 'ERROR_MSG',
      info = { 'INFORMATION' },
      pass = {},
      warning = { 'WARN_X', 'WARN_Y' },
    },
    pattern = { '%/var%/log%/.*', 'console%-ramoops.*', 'log.*%.txt', 'logcat.*', '.*%.log' },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
