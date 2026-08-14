---@module 'lazy'
return { ---@type LazySpec
  's1n7ax/nvim-window-picker',
  name = 'window-picker',
  event = 'VeryLazy',
  version = false,
  config = function()
    require('window-picker').setup({
      filter_rules = {
        autoselect_one = true,
        bo = { filetype = { 'NvimTree', 'neo-tree', 'notify', 'snacks_notif', 'lazy' }, buftype = { 'terminal' } },
        file_name_contains = {},
        file_path_contains = {},
        include_current_win = true,
        include_unfocusable_windows = false,
        wo = {},
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
      hint = 'floating-letter',
      picker_config = {
        floating_big_letter = { font = 'ansi-shadow' },
        handle_mouse_click = false,
        statusline_winbar_picker = {
          selection_display = function(char)
            return '%=' .. char .. '%='
          end,
          use_winbar = 'smart',
        },
      },
      prompt_message = 'Pick window: ',
      selection_chars = 'FJDKSLA;CMRUEIWOQP',
      show_prompt = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
