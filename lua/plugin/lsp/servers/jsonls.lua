return { ---@type vim.lsp.ClientConfig
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = { provideFormatter = true },
    root_markers = { '.git' },
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
