---@module 'lazy'
return { ---@type LazySpec
  'jeangiraldoo/codedocs.nvim',
  version = false,
  config = function()
    require('codedocs').setup({
      logging = {
        level = vim.log.levels.INFO,
        path = vim.fs.joinpath(vim.fn.stdpath('log'), 'codedocs.log'),
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
