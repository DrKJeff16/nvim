---@module 'lazy'

return { ---@type LazySpec
    'onsails/lspkind.nvim',
    version = false,
    config = function()
        require('lspkind').init({ mode = 'symbol_text', preset = 'codicons', symbol_map = {} })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
