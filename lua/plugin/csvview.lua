---@module 'lazy'
return { ---@type LazySpec
  'hat0uma/csvview.nvim',
  version = false,
  ft = { 'csv' },
  cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
  config = function()
    require('csvview').setup({
      keymaps = {
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
      },
      parser = { comments = { '#', '//' } },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
