return { ---@type vim.lsp.ClientConfig
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'package.json', '.git' },
  settings = { ['rust-analyzer'] = { diagnostics = { enable = true } } },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
