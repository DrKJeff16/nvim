return { ---@type vim.lsp.ClientConfig
  cmd = { 'docker-language-server', 'start', '--stdio' },
  filetypes = { 'dockerfile', 'yaml.docker-compose' },
  root_markers = {
    'Dockerfile',
    'docker-compose.yaml',
    'docker-compose.yml',
    'compose.yaml',
    'compose.yml',
    'docker-bake.json',
    'docker-bake.hcl',
    'docker-bake.override.json',
    'docker-bake.override.hcl',
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
