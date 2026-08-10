---@module 'lazy'
return { ---@type LazySpec
  'gen740/SmoothCursor.nvim',
  version = false,
  cond = not require('user_api').check.in_console(),
  config = function()
    require('smoothcursor').setup({
      always_redraw = true,
      autostart = true,
      cursor = '',
      disable_float_win = true,
      fancy = {
        body = {
          { cursor = '󰝥', texthl = 'SmoothCursorRed' },
          { cursor = '󰝥', texthl = 'SmoothCursorOrange' },
          { cursor = '●', texthl = 'SmoothCursorYellow' },
          { cursor = '●', texthl = 'SmoothCursorGreen' },
          { cursor = '•', texthl = 'SmoothCursorAqua' },
          { cursor = '.', texthl = 'SmoothCursorBlue' },
          { cursor = '.', texthl = 'SmoothCursorPurple' },
        },
        enable = true,
        head = { cursor = '▷', texthl = 'SmoothCursor' },
        tail = { texthl = 'SmoothCursor' },
      },
      intervals = 35,
      matrix = {
        body = { cursor = require('smoothcursor.matrix_chars'), length = 6, texthl = { 'SmoothCursorGreen' } },
        head = { cursor = require('smoothcursor.matrix_chars'), texthl = { 'SmoothCursor' } },
        tail = { texthl = { 'SmoothCursor' } },
        unstop = false,
      },
      max_threshold = 6,
      priority = 10,
      speed = 25,
      texthl = 'SmoothCursor',
      threshold = 3,
      timeout = 3000,
      type = 'exp',
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
