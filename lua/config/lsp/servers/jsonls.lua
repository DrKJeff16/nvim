return { ---@type vim.lsp.ClientConfig
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = { provideFormatter = true },
  root_markers = { '.git' },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
