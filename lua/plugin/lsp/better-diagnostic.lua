---@module 'lazy'
return { ---@type LazySpec
  'sontungexpt/better-diagnostic-virtual-text',
  event = 'LspAttach',
  version = false,
  config = function()
    require('better-diagnostic-virtual-text').setup({
      inline = true,
      priority = 2003,
      ui = {
        above = false,
        arrow = '  ',
        down_arrow = '  ',
        left_kept_space = 3,
        right_kept_space = 3,
        up_arrow = '  ',
        wrap_line_after = false,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
