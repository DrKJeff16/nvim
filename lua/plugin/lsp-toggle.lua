---@module 'lazy'
return { ---@type LazySpec
  'NeoSahadeo/lsp-toggle.nvim',
  version = false,
  config = function()
    require('lsp-toggle').setup({
      cache = true,
      cache_type = 'file_type',
      exclude_lsp = { 'marksman', 'yamlls', 'taplo' },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
