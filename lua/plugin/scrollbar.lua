---@module 'lazy'

---@type LazySpec
return {
    'wsdjeg/scrollbar.vim',
    version = false,
    cond = not require('user_api.check').in_console(),
    config = function()
        require('scrollbar').setup({
            max_size = 10,
            min_size = 5,
            width = 1,
            right_offset = 1,
            shape = { head = '▲', body = '█', tail = '▼' },
            highlight = { head = 'Normal', body = 'Normal', tail = 'Normal' },
            excluded_filetypes = {
                'TelescopePrompt',
                'notify',
                'checkhealth',
                'help',
                'startify',
                'gitcommit',
                'NvimTree',
                'neo-tree',
                'lazy',
                'qf',
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
