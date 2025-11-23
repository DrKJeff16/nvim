---@module 'lazy'

return { ---@type LazySpec[]
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        version = false,
        dependencies = {
            'ibhagwan/ts-vimdoc.nvim',
            {
                'nvim-treesitter/nvim-treesitter-context',
                config = require('config.util').require('plugin.ts.context'),
            },
            {
                'windwp/nvim-ts-autotag',
                config = require('config.util').require('plugin.ts.autotag'),
            },
            {
                'JoosepAlviste/nvim-ts-context-commentstring',
                config = function()
                    require('ts_context_commentstring').setup({ enable_autocmd = false })
                end,
            },
        },
        config = require('config.util').require('plugin.ts'),
    },
    {
        'tjdevries/tree-sitter-lua',
        build = 'cargo build --release',
        version = false,
        enabled = false,
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
