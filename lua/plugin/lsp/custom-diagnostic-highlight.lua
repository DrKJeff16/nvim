---@module 'lazy'
return { ---@type LazySpec
  'Kasama/nvim-custom-diagnostic-highlight',
  event = 'LspAttach',
  version = false,
  config = function()
    require('nvim-custom-diagnostic-highlight').setup({
      register_handler = true,
      handler_name = 'Kasama/nvim-custom-diagnostic-highlight',
      highlight_group = 'Conceal',
      patterns_override = {
        '%sunused',
        '^unused',
        'not used',
        'never used',
        'not read',
        'never read',
        'empty block',
        'not accessed',
      },
      extra_patterns = {},
      diagnostic_handler_namespace = 'unused_hl_ns',
      defer_until_n_lines_away = false,
      defer_highlight_update_events = { 'CursorHold', 'CursorHoldI' },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
