---@module 'lazy'

---@type LazySpec
return {
    'A7Lavinraj/fyler.nvim',
    version = false,
    dependencies = { 'nvim-mini/mini.icons' },
    cond = not require('user_api.check').in_console(),
    config = function()
        require('fyler').setup({
            close_on_select = true,
            confirm_simple = false,
            default_explorer = false,
            git_status = {
                enabled = true,
                symbols = {
                    Untracked = '?',
                    Added = '+',
                    Modified = '*',
                    Deleted = 'x',
                    Renamed = '>',
                    Copied = '~',
                    Conflict = '!',
                    Ignored = '#',
                },
            },
            icon_provider = 'mini_icons',
            indentscope = { enabled = true, group = 'FylerIndentMarker', marker = '│' },
            mappings = {
                q = 'CloseView',
                ['<CR>'] = 'Select',
                ['<C-t>'] = 'SelectTab',
                ['|'] = 'SelectVSplit',
                ['-'] = 'SelectSplit',
                ['^'] = 'GotoParent',
                ['='] = 'GotoCwd',
                ['.'] = 'GotoNode',
                ['#'] = 'CollapseAll',
                ['<BS>'] = 'CollapseNode',
            },
            track_current_buffer = true,
            win = { border = 'single', kind = 'replace', buf_opts = {}, win_opts = {} },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
