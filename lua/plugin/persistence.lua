---@module 'lazy'

---@type LazySpec
return {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    version = false,
    config = function()
        require('persistence').setup({
            dir = vim.fn.stdpath('state') .. '/sessions/',
            need = 1,
            branch = false,
        })

        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = {
                ['<leader>s'] = { group = '+Session' },
                ['<leader>ss'] = { require('persistence').load, desc('Load Session') },
                ['<leader>sS'] = { require('persistence').select, desc('Select Session') },
                ['<leader>sd'] = { require('persistence').stop, desc('Stop Session') },
                ['<leader>sl'] = {
                    function()
                        require('persistence').load({ last = true })
                    end,
                    desc('Load Last Session'),
                },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
