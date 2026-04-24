---@module 'lazy'
return { ---@type LazySpec
  's1n7ax/nvim-window-picker',
  name = 'window-picker',
  event = 'VeryLazy',
  version = false,
  config = function()
    require('window-picker').setup({
      hint = 'floating-letter', ---@type 'statusline-winbar'|'floating-big-letter'|'floating-letter'
      selection_chars = 'FJDKSLA;CMRUEIWOQP',
      picker_config = {
        handle_mouse_click = false,
        statusline_winbar_picker = {
          selection_display = function(char)
            return '%=' .. char .. '%='
          end,
          use_winbar = 'smart', ---@type 'always'|'never'|'smart'
        },
        floating_big_letter = { font = 'ansi-shadow' },
      },
      show_prompt = true,
      prompt_message = 'Pick window: ',
      filter_rules = {
        autoselect_one = true,
        include_current_win = true,
        include_unfocusable_windows = false,
        bo = {
          filetype = { 'NvimTree', 'neo-tree', 'notify', 'snacks_notif', 'lazy' },
          buftype = { 'terminal' },
        },
        wo = {},
        file_path_contains = {},
        file_name_contains = {},
      },
      highlights = {
        enabled = true,
        statusline = {
          focused = { fg = '#ededed', bg = '#e35e4f', bold = true },
          unfocused = { fg = '#ededed', bg = '#44cc41', bold = true },
        },
        winbar = {
          focused = { fg = '#ededed', bg = '#e35e4f', bold = true },
          unfocused = { fg = '#ededed', bg = '#44cc41', bold = true },
        },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
