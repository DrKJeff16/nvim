---@module 'lazy'
return { ---@type LazySpec
  'sontungexpt/better-diagnostic-virtual-text',
  event = 'LspAttach',
  version = false,
  config = function()
    require('better-diagnostic-virtual-text').setup({
      ui = {
        wrap_line_after = false,
        left_kept_space = 3,
        right_kept_space = 3,
        arrow = '  ',
        up_arrow = '  ',
        down_arrow = '  ',
        above = false,
      },
      priority = 2003,
      inline = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
