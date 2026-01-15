---@module 'lazy'
---@module 'blink.pairs'
return { ---@type LazySpec
  'saghen/blink.pairs',
  version = false, -- (recommended) only required with prebuilt binaries
  build = 'cargo build --release',
  opts = { ---@type blink.pairs.Config
    mappings = { enabled = true, cmdline = true, disabled_filetypes = {}, pairs = {} },
    highlights = {
      enabled = true,
      cmdline = true,
      groups = { 'BlinkPairsOrange', 'BlinkPairsPurple', 'BlinkPairsBlue' },
      unmatched_group = 'BlinkPairsUnmatched',
      matchparen = {
        enabled = true,
        cmdline = false,
        include_surrounding = false,
        group = 'BlinkPairsMatchParen',
        priority = 250,
      },
    },
    debug = false,
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
