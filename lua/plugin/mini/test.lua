---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.test',
  version = false,
  config = function()
    require('mini.test').setup({
      execute = { reporter = nil, stop_on_error = true },
      silent = false,
      collect = {
        emulate_busted = true,
        find_files = function()
          return vim.fn.globpath('tests', '**/test_*.lua', true, true)
        end,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
