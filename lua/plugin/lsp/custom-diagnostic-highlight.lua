---@module 'lazy'
return { ---@type LazySpec
  'Kasama/nvim-custom-diagnostic-highlight',
  event = 'LspAttach',
  version = false,
  config = function()
    require('nvim-custom-diagnostic-highlight').setup({
      defer_highlight_update_events = { 'CursorHold', 'CursorHoldI' },
      defer_until_n_lines_away = false,
      diagnostic_handler_namespace = 'unused_hl_ns',
      extra_patterns = {},
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
      register_handler = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
