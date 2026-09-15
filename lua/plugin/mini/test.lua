---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.test',
  version = false,
  config = function()
    require('mini.test').setup({
      collect = {
        emulate_busted = true,
        find_files = function()
          return vim.fn.globpath('tests', '**/test_*.lua', true, true)
        end,
      },
      execute = { stop_on_error = true },
      silent = false,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
