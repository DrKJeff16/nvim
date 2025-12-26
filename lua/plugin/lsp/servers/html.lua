return { ---@type vim.lsp.ClientConfig
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ' },
  root_markers = { 'package.json', '.git' },
  init_options = {
    configurationSection = { 'html', 'css', 'javascript' },
    embeddedLanguages = { css = true, javascript = true },
    provideFormatter = true,
  },
  settings = {},
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
