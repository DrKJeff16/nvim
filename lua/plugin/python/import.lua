---@module 'lazy'
return { ---@type LazySpec
  'kiyoon/python-import.nvim',
  version = false,
  cond = require('user_api.check.exists').executable('uv'),
  build = 'uv tool install . --force --reinstall',
  ft = 'python',
  config = function()
    require('python_import').setup({})
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('PythonImport', { clear = true }),
      pattern = { 'python' },
      callback = function(ev)
        local Api = require('python_import.api')
        local desc = require('user_api.maps').desc
        require('user_api.config.keymaps').set({
          n = {
            ['<M-\\>'] = {
              Api.add_import_current_word_and_notify,
              desc('Add Python Import', true, ev.buf),
            },
            ['<leader>i'] = { group = 'Python Import', buffer = ev.buf },
            ['<leader>it'] = { Api.add_rich_traceback, desc('Add Rich Traceback', true, ev.buf) },
            ['<leader>ii'] = {
              Api.add_import_current_word_and_move_cursor,
              desc('Add python import and move cursor', true, ev.buf),
            },
          },
          i = {
            ['<M-\\>'] = {
              Api.add_import_current_word_and_notify,
              desc('Add Python Import', true, ev.buf),
            },
          },
          x = {
            ['<leader>i'] = {
              Api.add_import_current_selection_and_move_cursor,
              desc('Add Python Import and Move Cursor', true, ev.buf),
            },
            ['<M-\\>'] = {
              Api.add_import_current_selection_and_notify,
              desc('Add Python Import', true, ev.buf),
            },
          },
        }, ev.buf)
      end,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
