---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.diff',
  version = false,
  config = function()
    require('mini.diff').setup({
      delay = { text_change = 200 },
      mappings = {
        apply = 'gh',
        goto_first = '[H',
        goto_last = ']H',
        goto_next = ']h',
        goto_prev = '[h',
        reset = 'gH',
        textobject = 'gh',
      },
      options = { algorithm = 'histogram', indent_heuristic = true, linematch = 60, wrap_goto = false },
      view = {
        priority = 199,
        signs = { add = '▒', change = '▒', delete = '▒' },
        style = vim.o.number and 'number' or 'sign',
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
