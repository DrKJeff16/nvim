---@module 'lazy'

return { ---@type LazySpec
    'nvim-mini/mini.diff',
    version = false,
    config = function()
        require('mini.diff').setup({
            view = {
                style = vim.o.number and 'number' or 'sign',
                signs = { add = '▒', change = '▒', delete = '▒' },
                priority = 199,
            },
            source = nil,
            delay = { text_change = 200 },
            mappings = {
                apply = 'gh',
                reset = 'gH',
                textobject = 'gh',
                goto_first = '[H',
                goto_prev = '[h',
                goto_next = ']h',
                goto_last = ']H',
            },
            options = {
                algorithm = 'histogram',
                indent_heuristic = true,
                linematch = 60,
                wrap_goto = false,
            },
        })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
