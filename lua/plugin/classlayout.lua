---@module 'lazy'
return { ---@type LazySpec
  'J-Cowsert/classlayout.nvim',
  dev = true,
  ft = { 'c', 'cpp' },
  version = false,
  config = function()
    require('classlayout').setup({
      keymap = '<leader>lScl',
      compiler = 'clang',
      args = {},
      compile_commands = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
