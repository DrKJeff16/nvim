return { ---@type vim.lsp.ClientConfig
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.helm-values' },
  root_markers = { '.git' },
  settings = { redhat = { telemetry = { enabled = false } } },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
