---@module 'lazy'
return { ---@type LazySpec
  'lewis6991/satellite.nvim',
  dev = true,
  version = false,
  config = function()
    require('satellite').setup({
      current_only = false,
      excluded_filetypes = {},
      handlers = {
        cursor = { enable = true, symbols = { '⎺', '⎻', '⎼', '⎽' } },
        diagnostic = { enable = true, min_severity = vim.diagnostic.severity.HINT, signs = { '-', '=', '≡' } },
        gitsigns = { enable = true, signs = { add = '│', change = '│', delete = '-' } },
        marks = { enable = true, key = 'm', show_builtins = false },
        minidiff = { enable = true, signs = { add = '│', change = '│', delete = '-' } },
        quickfix = { signs = { '-', '=', '≡' } },
        search = { enable = true },
      },
      width = 2,
      winblend = 50,
      zindex = 40,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
