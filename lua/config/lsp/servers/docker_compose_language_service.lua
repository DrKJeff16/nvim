return { ---@type vim.lsp.ClientConfig
  cmd = { 'docker-compose-langserver', '--stdio' },
  filetypes = { 'yaml.docker-compose' },
  root_markers = { 'docker-compose.yaml', 'docker-compose.yml', 'compose.yaml', 'compose.yml' },
  settings = {},
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
