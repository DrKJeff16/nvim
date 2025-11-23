---@module 'lazy'

local ORG_PFX = vim.fn.expand('~/.org')

return { ---@type LazySpec
    'nvim-orgmode/orgmode',
    version = false,
    cond = not require('user_api.check').in_console(),
    config = function()
        require('orgmode').setup({
            org_startup_indented = true,
            org_adapt_indentation = true,
            org_agenda_files = ORG_PFX .. '/**/*',
            org_default_notes_file = ORG_PFX .. '/default.org',
            org_highlight_latex_and_related = 'native',
            org_todo_keywords = { 'TODO', 'WAITING', '|', 'DONE', 'DELEGATED' },
            org_todo_repeat_to_state = nil,
            org_todo_keyword_faces = {
                WAITING = ':foreground blue :weight bold',
                DELEGATED = ':background #FFFFFF :underline on',
            },
            org_hide_leading_stars = false,
            org_hide_emphasis_markers = false,
            org_ellipsis = '...',
            win_split_mode = 'auto',
            win_border = 'single',
            org_startup_folded = 'showeverything',
            org_babel_default_header_args = { [':tangle'] = 'no', [':noweb'] = 'no' },
            calendar_week_start_day = 0,
        })

        require('user_api.config').keymaps({ n = { ['<leader>o'] = { group = '+Orgmode' } } })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
