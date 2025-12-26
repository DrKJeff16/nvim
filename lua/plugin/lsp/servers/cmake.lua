return { ---@type vim.lsp.ClientConfig
  cmd = { 'cmake-language-server' },
  filetypes = { 'cmake' },
  init_options = { buildDirectory = 'build' },
  root_markers = { '.git', 'CMakePresets.json', 'CTestConfig.cmake', 'build', 'cmake' },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
