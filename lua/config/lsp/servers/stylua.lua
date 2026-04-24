return { ---@type vim.lsp.ClientConfig
  cmd = { 'stylua', '--lsp' },
  filetypes = { 'lua' },
  root_markers = { '.stylua.toml', 'stylua.toml', '.editorconfig' },
  settings = {},
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
