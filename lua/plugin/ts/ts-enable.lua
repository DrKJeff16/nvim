---@module 'lazy'
return { ---@type LazySpec
  'VonHeikemen/ts-enable.nvim',
  version = false,
  config = function()
    vim.g.ts_enable = { auto_init = true, auto_install = true, highlights = true, folds = false }
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
