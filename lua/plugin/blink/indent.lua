---@module 'lazy'
return { ---@type LazySpec
  'saghen/blink.indent',
  version = false,
  cond = not require('user_api.check').in_console(),
  config = function()
    require('blink.indent').setup({
      blocked = { buftypes = { include_defaults = true }, filetypes = { include_defaults = true } },
      mappings = {
        border = 'both',
        object_scope = 'ii',
        object_scope_with_border = 'ai',
        goto_top = '[i',
        goto_bottom = ']i',
      },
      static = { enabled = false },
      scope = {
        enabled = true,
        indent_at_cursor = false,
        char = '▎',
        priority = 1000,
        highlights = {
          'BlinkIndentViolet',
          'BlinkIndentBlue',
          'BlinkIndentRed',
          'BlinkIndentCyan',
          'BlinkIndentGreen',
        },
        underline = {
          enabled = true,
          highlights = {
            'BlinkIndentVioletUnderline',
            'BlinkIndentBlueUnderline',
            'BlinkIndentRedUnderline',
            'BlinkIndentCyanUnderline',
            'BlinkIndentGreenUnderline',
          },
        },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
