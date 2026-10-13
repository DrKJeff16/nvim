---@module 'lazy'
return { ---@type LazySpec
  'antosha417/nvim-lsp-file-operations',
  dev = true,
  version = false,
  event = 'VeryLazy',
  dependencies = { 'nvim-neo-tree/neo-tree.nvim' },
  config = function()
    require('lsp-file-operations').setup({ auto_save = true })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
