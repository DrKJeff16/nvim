---@module 'lazy'
return { ---@type LazySpec
  'mghaight/replua.nvim',
  version = false,
  config = function()
    require('replua').setup({
      error_prefix = '-- Error: ',
      intro_lines = { '-- Scratch buffer for Lua evaluation', '' },
      keymaps = { eval_block = '<leader>r<CR>', eval_buffer = '<leader>rb', eval_line = '<leader>rl' },
      newline_after_result = true,
      open_command = 'enew',
      persist_env = true,
      print_prefix = '-- print: ',
      result_continuation_prefix = '--    ',
      result_prefix = '-- => ',
      show_nil_results = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
