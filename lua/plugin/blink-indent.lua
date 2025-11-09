---@module 'lazy'

---@type LazySpec
return {
    'saghen/blink.indent',
    dev = true,
    version = false,
    cond = not require('user_api.check').in_console(),
    config = function()
        require('blink.indent').setup({
            blocked = {
                buftypes = { include_defaults = true },
                filetypes = { include_defaults = true },
            },
            static = {
                enabled = true,
                char = '▎',
                priority = 1,
                highlights = { 'BlinkIndentCyan', 'BlinkIndentGreen', 'BlinkIndentBlue' },
            },
            scope = {
                enabled = true,
                char = '▎',
                priority = 1000,
                highlights = { 'BlinkIndentRed', 'BlinkIndentYellow', 'BlinkIndentOrange' },
                underline = {
                    enabled = true,
                    highlights = {
                        'BlinkIndentOrangeUnderline',
                        'BlinkIndentVioletUnderline',
                        'BlinkIndentBlueUnderline',
                    },
                },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
