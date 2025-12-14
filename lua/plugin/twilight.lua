---@module 'lazy'

return { ---@type LazySpec
    'folke/twilight.nvim',
    version = false,
    cond = not require('user_api.check').in_console(),
    config = function()
        local Twilight = require('twilight')
        Twilight.setup({
            dimming = {
                alpha = 0.4,
                color = { 'Normal', '#ffffff' },
                term_bg = '#000000',
                inactive = true,
            },
            context = 10,
            treesitter = true,
            expand = { 'function', 'method', 'table', 'if_statement' },
            exclude = {},
        })

        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = {
                ['<leader>ut'] = { group = '+Twilight' },
                ['<leader>utt'] = { Twilight.toggle, desc('Toggle Twilight') },
                ['<leader>ute'] = { Twilight.enable, desc('Enable Twilight') },
                ['<leader>utd'] = { Twilight.disable, desc('Disable Twilight') },
            },
        })
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
