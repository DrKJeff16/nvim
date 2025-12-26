return { ---@type vim.lsp.ClientConfig
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
  root_markers = { 'Dockerfile' },
  settings = {
    docker = { languageserver = { formatter = { ignoreMultilineInstructions = true } } },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
