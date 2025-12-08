---@module 'lazy'

return { ---@type LazySpec
    'ahkohd/buffer-sticks.nvim',
    version = false,
    config = function()
        require('buffer-sticks').setup({
            position = 'right', ---@type 'right'|'left'
            width = 3,
            offset = { x = 1, y = 0 },
            active_char = '──',
            inactive_char = ' ─',
            jump = { show = { 'filename', 'space', 'label' } },
            label = { show = 'always' },
            transparent = true,
            filter = { filetypes = { 'terminal' } },
            highlights = {
                active = { link = 'Statement' },
                inactive = { link = 'Whitespace' },
                label = { link = 'Comment' },
            },
        })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
