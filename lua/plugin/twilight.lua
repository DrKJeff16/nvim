---@module 'lazy'

---@type LazySpec
return {
    'folke/twilight.nvim',
    version = false,
    cond = not require('user_api.check').in_console(),
    config = function()
        require('twilight').setup({
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
                ['<leader>utt'] = { require('twilight').toggle, desc('Toggle Twilight') },
                ['<leader>ute'] = { require('twilight').enable, desc('Enable Twilight') },
                ['<leader>utd'] = { require('twilight').disable, desc('Disable Twilight') },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
