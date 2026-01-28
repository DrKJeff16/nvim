---@module 'lazy'
return { ---@type LazySpec
  'm-demare/hlargs.nvim',
  dev = true,
  version = false,
  config = function()
    require('hlargs').setup({
      color = '#20df92',
      highlight = {},
      paint_arg_declarations = true,
      paint_arg_usages = true,
      paint_catch_blocks = { declarations = false, usages = false },
      extras = { named_parameters = false, unused_args = false },
      hl_priority = 300,
      excluded_argnames = {
        declarations = {},
        usages = { python = { 'self', 'cls' }, lua = { 'self' } },
      },
      performance = {
        parse_delay = 1,
        slow_parse_delay = 50,
        max_iterations = 400,
        max_concurrent_partial_parses = 30,
        debounce = {
          partial_parse = 3,
          partial_insert_mode = 100,
          total_parse = 700,
          slow_parse = 5000,
        },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
