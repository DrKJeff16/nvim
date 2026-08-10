---@module 'lazy'
return { ---@type LazySpec
  'wsdjeg/picker.nvim',
  dev = true,
  event = 'VeryLazy',
  version = false,
  dependencies = { { 'wsdjeg/job.nvim', dev = true } },
  config = function()
    require('picker').setup({
      filter = { ignorecase = false, matcher = 'fzy' },
      highlight = { matched = 'Tag', score = 'Comment' },
      window = {
        col = 0.1,
        current_icon = '>',
        current_icon_hl = 'CursorLine',
        enable_preview = true,
        height = 0.8,
        preview_timeout = 500,
        row = 0.1,
        show_score = true,
        width = 0.8,
      },
      prompt = { icon = '>', icon_hl = 'Error', insert_timeout = 100, position = 'top', title = true },
      mappings = {
        close = '<Esc>',
        next_item = '<Tab>',
        open_item = '<Enter>',
        previous_item = '<S-Tab>',
        toggle_preview = '<C-p>',
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
