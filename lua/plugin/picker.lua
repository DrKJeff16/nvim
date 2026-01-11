---@module 'lazy'
return { ---@type LazySpec
  'wsdjeg/picker.nvim',
  version = false,
  cmd = { 'Picker' },
  opts = {
    window = {
      width = 0.8,
      height = 0.8,
      col = 0.1,
      row = 0.1,
      current_icon = '>',
      current_icon_hl = 'CursorLine',
      enable_preview = false,
      preview_timeout = 500,
    },
    highlight = { matched = 'Tag' },
    prompt = { position = 'bottom', icon = '>', icon_hl = 'Error' },
    mappings = {
      close = '<Esc>',
      next_item = '<Down>',
      previous_item = '<Up>',
      open_item = '<Enter>',
      toggle_preview = '<C-p>',
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
