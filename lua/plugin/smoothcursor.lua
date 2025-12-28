---@module 'lazy'
return { ---@type LazySpec
  'gen740/SmoothCursor.nvim',
  version = false,
  cond = not require('user_api.check').in_console(),
  config = function()
    require('smoothcursor').setup({
      type = 'default', ---@type 'default'|'exp'|'matrix'
      cursor = '',
      max_threshold = 6,
      texthl = 'SmoothCursor',
      fancy = {
        enable = true,
        head = { cursor = '▷', texthl = 'SmoothCursor', linehl = nil },
        body = {
          { cursor = '󰝥', texthl = 'SmoothCursorRed' },
          { cursor = '󰝥', texthl = 'SmoothCursorOrange' },
          { cursor = '●', texthl = 'SmoothCursorYellow' },
          { cursor = '●', texthl = 'SmoothCursorGreen' },
          { cursor = '•', texthl = 'SmoothCursorAqua' },
          { cursor = '.', texthl = 'SmoothCursorBlue' },
          { cursor = '.', texthl = 'SmoothCursorPurple' },
        },
        tail = { cursor = nil, texthl = 'SmoothCursor' },
      },
      matrix = {
        unstop = false,
        tail = { texthl = { 'SmoothCursor' } },
        head = { cursor = require('smoothcursor.matrix_chars'), texthl = { 'SmoothCursor' } },
        body = {
          length = 6,
          cursor = require('smoothcursor.matrix_chars'),
          texthl = { 'SmoothCursorGreen' },
        },
      },
      autostart = true,
      always_redraw = true,
      speed = 25,
      intervals = 35,
      priority = 10,
      timeout = 3000,
      threshold = 3,
      disable_float_win = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
