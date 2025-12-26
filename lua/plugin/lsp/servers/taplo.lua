return { ---@type vim.lsp.ClientConfig
  cmd = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' },
  root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
