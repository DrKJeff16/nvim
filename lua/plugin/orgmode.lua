---@module 'lazy'

local floor = math.floor
local ORG_PFX = vim.fn.expand('~/.org')

---@type LazySpec
return {
    'nvim-orgmode/orgmode',
    ft = 'org',
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
            win_split_mode = function(name) ---@param name string
                local bufnr = vim.api.nvim_create_buf(false, false)
                local width = floor(vim.o.columns * 0.8)
                local height = floor(vim.o.lines * 0.8)
                local row = floor(((vim.o.lines - height) / 2) - 1)
                local col = floor((vim.o.columns - width) / 2)
                vim.api.nvim_buf_set_name(bufnr, name)
                vim.api.nvim_open_win(bufnr, true, {
                    relative = 'editor',
                    width = width,
                    height = height,
                    row = row,
                    col = col,
                    style = 'minimal',
                    border = 'rounded',
                })
            end,
            win_border = 'single',
            org_startup_folded = 'showeverything',
            org_babel_default_header_args = { [':tangle'] = 'no', [':noweb'] = 'no' },
            calendar_week_start_day = 0,
        })
        require('user_api.config').keymaps({ n = { ['<leader>o'] = { group = '+Orgmode' } } })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
