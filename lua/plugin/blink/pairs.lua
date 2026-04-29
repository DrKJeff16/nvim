---@module 'lazy'
---@module 'blink.pairs'
return { ---@type LazySpec
  'saghen/blink.pairs',
  version = false,
  config = function()
    require('blink.pairs').setup({
      mappings = {
        enabled = true,
        cmdline = true,
        disabled_filetypes = {},
        wrap = { ['<C-b>'] = 'motion', ['<C-S-b>'] = 'motion_reverse' },
        pairs = {},
      },
      highlights = {
        enabled = true,
        cmdline = true,
        groups = { 'BlinkPairsOrange', 'BlinkPairsPurple', 'BlinkPairsBlue' },
        unmatched_group = 'BlinkPairsUnmatched',
        matchparen = {
          enabled = true,
          cmdline = true,
          include_surrounding = false,
          group = 'BlinkPairsMatchParen',
          priority = 250,
        },
      },
      debug = false,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
