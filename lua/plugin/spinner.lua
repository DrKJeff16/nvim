---@module 'lazy'
return { ---@type LazySpec
  'xieyonn/spinner.nvim',
  dev = true,
  version = false,
  event = 'VeryLazy',
  dependencies = {},
  config = function()
    require('spinner').setup({
      cursor_spinner = { col = 1, row = -1, winblend = 60, zindex = 50 },
      initial_delay_ms = 0,
      pattern = 'dots',
      placeholder = false,
      ttl_ms = 0,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
