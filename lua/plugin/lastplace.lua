---@module 'lazy'

return { ---@type LazySpec
    'nxhung2304/lastplace.nvim',
    version = false,
    config = function()
        require('lastplace').setup({
            ignore_filetypes = {
                'gitcommit',
                'gitrebase',
                'svn',
                'hgcommit',
                'xxd',
                'COMMIT_EDITMSG',
            },
            ignore_buftypes = { 'quickfix', 'nofile', 'help', 'terminal' },
            center_on_jump = true,
            jump_only_if_not_visible = false,
            min_lines = 10,
            max_line = 0,
            open_folds = true,
            debug = false,
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
