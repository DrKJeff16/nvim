---@module 'lazy'
return { ---@type LazySpec
  'ahkohd/buffer-sticks.nvim',
  version = false,
  config = function()
    require('buffer-sticks').setup({
      active_char = '──',
      filter = { filetypes = { 'terminal' } },
      highlights = {
        active = { link = 'Statement' },
        inactive = { link = 'Whitespace' },
        label = { link = 'Comment' },
      },
      inactive_char = ' ─',
      jump = { show = { 'filename', 'space', 'label' } },
      label = { show = 'always' },
      offset = { x = 1, y = 0 },
      position = 'right', ---@type 'right'|'left'
      transparent = true,
      width = 3,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
