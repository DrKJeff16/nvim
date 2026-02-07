return { ---@type vim.lsp.ClientConfig
  cmd = { 'asm-lsp' },
  filetypes = { 'asm', 'vmasm' },
  root_markers = { '.asm-lsp.toml', '.git' },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
