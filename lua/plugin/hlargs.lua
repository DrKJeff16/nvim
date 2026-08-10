---@module 'lazy'
return { ---@type LazySpec
  'm-demare/hlargs.nvim',
  dev = true,
  version = false,
  config = function()
    require('hlargs').setup({
      color = '#20df92',
      excluded_argnames = { declarations = {}, usages = { lua = { 'self' }, python = { 'self', 'cls' } } },
      extras = { named_parameters = false, unused_args = false },
      highlight = {},
      hl_priority = 300,
      paint_arg_declarations = true,
      paint_arg_usages = true,
      paint_catch_blocks = { declarations = false, usages = false },
      performance = {
        debounce = { partial_insert_mode = 100, partial_parse = 3, slow_parse = 5000, total_parse = 700 },
        max_concurrent_partial_parses = 30,
        max_iterations = 400,
        parse_delay = 1,
        slow_parse_delay = 50,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
