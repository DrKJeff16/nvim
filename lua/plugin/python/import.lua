---@module 'lazy'
return { ---@type LazySpec
  'kiyoon/python-import.nvim',
  version = false,
  build = 'uv tool install . --force --reinstall',
  ft = 'python',
  keys = {
    {
      '<M-CR>',
      function()
        require('python_import.api').add_import_current_word_and_notify()
      end,
      mode = { 'i', 'n' },
      silent = true,
      desc = 'Add python import',
      ft = 'python',
    },
    {
      '<M-CR>',
      function()
        require('python_import.api').add_import_current_selection_and_notify()
      end,
      mode = 'x',
      silent = true,
      desc = 'Add python import',
      ft = 'python',
    },
    {
      '<leader>i',
      function()
        require('python_import.api').add_import_current_word_and_move_cursor()
      end,
      mode = 'n',
      silent = true,
      desc = 'Add python import and move cursor',
      ft = 'python',
    },
    {
      '<leader>i',
      function()
        require('python_import.api').add_import_current_selection_and_move_cursor()
      end,
      mode = 'x',
      silent = true,
      desc = 'Add python import and move cursor',
      ft = 'python',
    },
    {
      '<leader>tr',
      function()
        require('python_import.api').add_rich_traceback()
      end,
      silent = true,
      desc = 'Add rich traceback',
      ft = 'python',
    },
  },
  opts = {},
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
