---@module 'lazy'
return { ---@type LazySpec
  'wsdjeg/picker.nvim',
  dev = true,
  event = 'VeryLazy',
  version = false,
  dependencies = { 'wsdjeg/job.nvim' },
  config = function()
    require('picker').setup({
      filter = { ignorecase = false, matcher = 'fzy' },
      highlight = { matched = 'Tag', score = 'Comment' },
      window = {
        width = 0.8,
        height = 0.8,
        col = 0.1,
        row = 0.1,
        current_icon = '>',
        current_icon_hl = 'CursorLine',
        enable_preview = true,
        preview_timeout = 500,
        show_score = true,
      },
      prompt = {
        position = 'top',
        icon = '>',
        icon_hl = 'Error',
        insert_timeout = 100,
        title = true,
      },
      mappings = {
        close = '<Esc>',
        next_item = '<Tab>',
        previous_item = '<S-Tab>',
        open_item = '<Enter>',
        toggle_preview = '<C-p>',
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
