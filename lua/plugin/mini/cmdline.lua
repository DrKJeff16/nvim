---@module 'lazy'

return { ---@type LazySpec
    'nvim-mini/mini.cmdline',
    version = false,
    config = function()
        require('mini.cmdline').setup({
            autocomplete = { enable = false, delay = 0, predicate = nil, map_arrows = true },
            autocorrect = { enable = true, func = nil },
            autopeek = {
                enable = true,
                n_context = 1,
                window = { config = {}, statuscolumn = nil },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
