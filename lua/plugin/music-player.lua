---@module 'lazy'

local Check = require('user_api.check')
return { ---@type LazySpec
  'ricmonmol/nvim-music-player',
  dev = true,
  version = false,
  build = ':UpdateRemotePlugins',
  enabled = not (Check.in_console() or Check.is_root()),
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
