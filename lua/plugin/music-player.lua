---@module 'lazy'
return { ---@type LazySpec
  'ricmonmol/nvim-music-player',
  version = false,
  build = ':UpdateRemotePlugins',
  enabled = not (require('user_api.check').in_console() or require('user_api.check').is_root()),
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
