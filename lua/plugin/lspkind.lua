---@module 'lazy'
return { ---@type LazySpec
  'onsails/lspkind.nvim',
  dev = true,
  lazy = true,
  version = false,
  config = function()
    require('lspkind').setup({ mode = 'symbol_text', preset = 'default' })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
