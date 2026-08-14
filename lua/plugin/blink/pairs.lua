---@module 'lazy'
---@module 'blink.pairs'
return { ---@type LazySpec
  'saghen/blink.pairs',
  version = false,
  dependencies = { 'saghen/blink.lib' },
  cond = require('user_api').check.executable('cargo'),
  build = function()
    require('blink.pairs').build({ force = true }):pwait(60000)
  end,
  config = function()
    require('blink.pairs').setup({
      debug = false,
      highlights = {
        cmdline = true,
        enabled = true,
        groups = { 'BlinkPairsOrange', 'BlinkPairsPurple', 'BlinkPairsBlue' },
        matchparen = {
          cmdline = true,
          enabled = true,
          group = 'BlinkPairsMatchParen',
          include_surrounding = false,
          priority = 250,
        },
        unmatched_group = 'BlinkPairsUnmatched',
      },
      mappings = {
        enabled = true,
        cmdline = true,
        disabled_filetypes = {},
        wrap = { ['<C-b>'] = 'motion', ['<C-S-b>'] = 'motion_reverse' },
        pairs = {},
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
