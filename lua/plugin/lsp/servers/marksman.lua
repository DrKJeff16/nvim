return { ---@type vim.lsp.ClientConfig
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown', 'markdown.mdx' },
  root_markers = { '.git', '.marksman.toml' },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
