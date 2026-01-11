---@module 'lazy'
return { ---@type LazySpec
  'rhysd/vim-syntax-codeowners',
  lazy = false,
  version = false,
  init = require('config.util').flag_installed('codeowners'),
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
