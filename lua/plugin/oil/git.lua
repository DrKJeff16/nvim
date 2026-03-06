---@module 'lazy'
return { ---@type LazySpec
  'malewicz1337/oil-git.nvim',
  version = false,
  dependencies = { 'stevearc/oil.nvim' },
  config = function()
    require('oil-git').setup({
      debounce_ms = 50,
      show_file_highlights = true,
      show_directory_highlights = true,
      show_file_symbols = true,
      show_directory_symbols = true,
      show_ignored_files = false,
      show_ignored_directories = false,
      symbol_position = 'eol', ---@type 'eol'|'signcolumn'|'none'
      ignore_gitsigns_update = false,
      debug = false, ---@type false|'minimal'|'verbose'
      symbols = {
        file = {
          added = '+',
          modified = '~',
          renamed = '->',
          deleted = 'D',
          copied = 'C',
          conflict = '!',
          untracked = '?',
          ignored = 'o',
        },
        directory = {
          added = '*',
          modified = '*',
          renamed = '*',
          deleted = '*',
          copied = '*',
          conflict = '!',
          untracked = '*',
          ignored = 'o',
        },
      },
      highlights = {
        OilGitAdded = { fg = '#a6e3a1' },
        OilGitModified = { fg = '#f9e2af' },
        OilGitRenamed = { fg = '#cba6f7' },
        OilGitDeleted = { fg = '#f38ba8' },
        OilGitCopied = { fg = '#cba6f7' },
        OilGitConflict = { fg = '#fab387' },
        OilGitUntracked = { fg = '#89b4fa' },
        OilGitIgnored = { fg = '#6c7086' },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
