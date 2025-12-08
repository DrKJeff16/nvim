---@module 'lazy'

return { ---@type LazySpec
    'NeoSahadeo/lsp-toggle.nvim',
    version = false,
    config = function()
        require('lsp-toggle').setup({
            cache = true,
            cache_type = 'file_type',
            exclude_lsp = { 'marksman', 'yamlls', 'taplo' },
        })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
