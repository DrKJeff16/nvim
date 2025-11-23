---@module 'lazy'

return { ---@type LazySpec[]
    'neovim/nvim-lspconfig',
    'folke/trouble.nvim',
    'b0o/SchemaStore.nvim',
    {
        'NeoSahadeo/lsp-toggle.nvim',
        version = false,
        config = function()
            require('lsp-toggle').setup({
                cache = true,
                cache_type = 'file_type',
                exclude_lsp = { 'marksman', 'yamlls', 'taplo' },
            })
        end,
    },
    {
        'romus204/referencer.nvim',
        version = false,
        cond = false,
        config = function()
            require('referencer').setup()
        end,
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
