return { ---@type vim.lsp.ClientConfig
    cmd = { 'taplo', 'lsp', 'stdio' },
    filetypes = { 'toml' },
    root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
