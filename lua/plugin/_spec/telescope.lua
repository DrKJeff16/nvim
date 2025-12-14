---@module 'lazy'

return { ---@type LazySpec

    'nvim-telescope/telescope.nvim',
    version = false,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-lua/plenary.nvim',
        'debugloop/telescope-undo.nvim',
        'OliverChao/telescope-picker-list.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        'crispgm/telescope-heading.nvim',
        { 'tpope/vim-fugitive', verbose = false },
        { 'polirritmico/telescope-lazy-plugins.nvim', dev = true },
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
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
