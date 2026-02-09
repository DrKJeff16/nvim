---@module 'lazy'
return { ---@type LazySpec
  'xieyonn/spinner.nvim',
  dev = true,
  version = false,
  dependencies = {},
  opts = {
    pattern = 'dots',
    ttl_ms = 0,
    initial_delay_ms = 0,
    placeholder = false,
    cursor_spinner = {
      hl_group = 'Spinner',
      winblend = 60,
      zindex = 50,
      row = -1,
      col = 1,
      border = 'none',
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
