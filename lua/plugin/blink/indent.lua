---@module 'lazy'
return { ---@type LazySpec
  'saghen/blink.indent',
  version = false,
  cond = not require('user_api').check.in_console(),
  config = function()
    require('blink.indent').setup({
      blocked = { buftypes = { include_defaults = true }, filetypes = { include_defaults = true } },
      mappings = {
        border = 'both',
        goto_bottom = ']i',
        goto_top = '[i',
        object_scope = 'ii',
        object_scope_with_border = 'ai',
      },
      scope = {
        char = '▎',
        enabled = true,
        highlights = {
          'BlinkIndentBlue',
          'BlinkIndentCyan',
          'BlinkIndentGreen',
          'BlinkIndentRed',
          'BlinkIndentViolet',
        },
        indent_at_cursor = false,
        priority = 1000,
        underline = {
          enabled = true,
          highlights = {
            'BlinkIndentBlueUnderline',
            'BlinkIndentCyanUnderline',
            'BlinkIndentGreenUnderline',
            'BlinkIndentRedUnderline',
            'BlinkIndentVioletUnderline',
          },
        },
      },
      static = { enabled = false },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
