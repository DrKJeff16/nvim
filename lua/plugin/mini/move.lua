---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.move',
    version = false,
    config = function()
        require('mini.move').setup({
            mappings = {
                left = '<C-Left>',
                right = '<C-Right>',
                down = '<C-Down>',
                up = '<C-Up>',
                line_left = '<C-Left>',
                line_right = '<C-Right>',
                line_down = '<C-Down>',
                line_up = '<C-Up>',
            },
            options = { reindent_linewise = true },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
