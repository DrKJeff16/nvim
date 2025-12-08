return { ---@type vim.lsp.ClientConfig
    cmd = { 'cspell-lsp', '--stdio' },
    root_markers = {
        '.git',
        'cspell.json',
        '.cspell.json',
        'cspell.json',
        '.cSpell.json',
        'cSpell.json',
        'cspell.config.js',
        'cspell.config.cjs',
        'cspell.config.json',
        'cspell.config.yaml',
        'cspell.config.yml',
        'cspell.yaml',
        'cspell.yml',
    },
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
