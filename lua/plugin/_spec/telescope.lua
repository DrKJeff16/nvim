---@module 'lazy'

---@type LazySpec[]
return {
    {
        'nvim-telescope/telescope.nvim',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-lua/plenary.nvim',
            'debugloop/telescope-undo.nvim',
            'OliverChao/telescope-picker-list.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'crispgm/telescope-heading.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                version = false,
                build = require('config.util').tel_fzf_build(),
                cond = require('user_api.check.exists').executable('fzf'),
            },
            {
                'LukasPietzschmann/telescope-tabs',
                version = false,
                config = require('config.util').require('plugin.telescope.tabs'),
            },
            {
                'DrKJeff16/telescope-makefile',
                ft = 'make',
                version = false,
                dependencies = { 'akinsho/toggleterm.nvim' },
                config = require('config.util').require('plugin.telescope.makefile'),
            },
            { 'olacin/telescope-cc.nvim', ft = 'gitcommit', version = false },
        },
        config = require('config.util').require('plugin.telescope'),
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
