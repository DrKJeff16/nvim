return { ---@type vim.lsp.ClientConfig
  cmd = { 'cssmodules-language-server' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'package.json' },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
