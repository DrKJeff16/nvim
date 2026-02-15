---@module 'lazy'
return { ---@type LazySpec
  'aikhe/wrapped.nvim',
  dev = true,
  version = false,
  dependencies = { { 'nvzone/volt', dev = true }, 'nvim-lua/plenary.nvim' },
  config = function()
    require('wrapped').setup({
      path = vim.fn.stdpath('config'),
      border = true,
      size = { width = 120, height = 40 },
      exclude_filetype = { '.gitmodules' },
      cap = {
        commits = 1000,
        plugins = 100,
        plugins_ever = 200,
        lines = 10000,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
