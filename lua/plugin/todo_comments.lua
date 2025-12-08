---@module 'lazy'

local uv = vim.uv or vim.loop
local in_list = vim.list_contains

---@param direction 'next'|'prev'
---@param keywords string[]
---@return function
local function jump(direction, keywords)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('direction', direction, 'string', false, "'next'|'prev'")
        vim.validate('keywords', keywords, 'table', false, 'string[]')
    else
        vim.validate({
            direction = { direction, 'string' },
            keywords = { keywords, 'table' },
        })
    end
    if not in_list({ 'next', 'prev' }, direction) then
        error(('(plugin.todo_comments:jump): Invalid direction `%s`!'):format(direction))
    end
    if vim.tbl_isempty(keywords) then
        error('(plugin.todo_comments:jump): No available keywords!')
    end

    local direction_map = {
        next = require('todo-comments').jump_next,
        prev = require('todo-comments').jump_prev,
    }
    return function()
        local func = direction_map[direction]
        func({ keywords = keywords })
    end
end

return { ---@type LazySpec
    'folke/todo-comments.nvim',
    version = false,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
    },
    cond = require('user_api.check.exists').executable('rg')
        and not require('user_api.check').in_console(),
    config = function()
        require('todo-comments').setup({
            signs = true,
            sign_priority = 8,
            keywords = {
                TITLE = {
                    icon = '! ',
                    color = '#00886d',
                    alt = { 'SECTION', 'BLOCK', 'CODESECTION', 'SECTIONTITLE', 'CODETITLE' },
                },
                FIX = {
                    icon = ' ',
                    color = 'error',
                    alt = {
                        'FIXME',
                        'BUG',
                        'FIXIT',
                        'ISSUE',
                        'TOFIX',
                        'SOLVE',
                        'TOSOLVE',
                        'SOLVEIT',
                    },
                },
                TODO = {
                    icon = ' ',
                    color = 'info',
                    alt = { 'PENDING', 'MISSING' },
                },
                HACK = {
                    icon = ' ',
                    color = 'warning',
                    alt = { 'TRICK', 'SOLUTION', 'ADHOC', 'SOLVED' },
                },
                WARN = {
                    icon = ' ',
                    color = 'warning',
                    alt = { 'ATTENTION', 'ISSUE', 'PROBLEM', 'WARNING', 'XXX' },
                },
                PERF = {
                    icon = ' ',
                    color = 'info',
                    alt = { 'OPTIM', 'OPTIMIZED', 'PERFORMANCE' },
                },
                NOTE = {
                    icon = ' ',
                    color = 'hint',
                    alt = { 'INFO', 'MINDTHIS', 'TONOTE', 'WATCH' },
                },
                TEST = {
                    icon = '⏲ ',
                    color = 'test',
                    alt = { 'TESTING', 'PASSED', 'FAILED' },
                },
            },
            gui_style = { fg = 'NONE', bg = 'BOLD' },
            merge_keywords = true,
            highlight = {
                multiline = true,
                multiline_pattern = '^.',
                multiline_context = 1,
                before = '',
                keyword = 'wide_fg',
                after = 'fg',
                pattern = [[.*<(KEYWORDS)\s*:]],
                comments_only = true,
                max_line_len = 250,
                exclude = {},
            },
            colors = {
                error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
                warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
                info = { 'DiagnosticInfo', '#2563EB' },
                hint = { 'DiagnosticHint', '#10B981' },
                default = { 'Identifier', '#7C3AED' },
                test = { 'Identifier', '#FF00FF' },
            },
            search = {
                command = 'rg',
                args = {
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                },
                pattern = [[\b(KEYWORDS):]],
            },
        })

        local KEYWORDS = { ---@class TODOKeywords
            TODO = { 'TODO', 'PENDING', 'MISSING' },
            FIX = {
                'FIX',
                'FIXME',
                'BUG',
                'FIXIT',
                'ISSUE',
                'TOFIX',
                'SOLVE',
                'TOSOLVE',
                'SOLVEIT',
            },
            HACK = { 'HACK', 'TRICK', 'SOLUTION', 'ADHOC', 'SOLVED' },
            NOTE = { 'NOTE', 'INFO', 'MINDTHIS', 'TONOTE', 'WATCH' },
            WARN = { 'WARN', 'ATTENTION', 'ISSUE', 'PROBLEM', 'WARNING', 'XXX' },
            TITLE = { 'TITLE', 'SECTION', 'BLOCK', 'CODESECTION', 'SECTIONTITLE', 'CODETITLE' },
            TEST = { 'TEST', 'TESTING', 'PASSED', 'FAILED' },
            PERF = { 'PERF', 'OPTIM', 'OPTIMIZED', 'PERFORMANCE' },
        }

        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = {
                ['<leader>c'] = { group = '+Comments' },
                ['<leader>cf'] = { group = "+'FIX'" },
                ['<leader>cw'] = { group = "+'WARNING'" },
                ['<leader>ct'] = { group = "+'TODO'" },
                ['<leader>cn'] = { group = "+'NOTE'" },
                ['<leader>ctn'] = { jump('next', KEYWORDS.TODO), desc("Next 'TODO' Comment") },
                ['<leader>ctp'] = { jump('prev', KEYWORDS.TODO), desc("Previous 'TODO' Comment") },
                ['<leader>cfn'] = { jump('next', KEYWORDS.FIX), desc("Next 'FIX' Comment") },
                ['<leader>cfp'] = { jump('prev', KEYWORDS.FIX), desc("Previous 'FIX' Comment") },
                ['<leader>cwn'] = { jump('next', KEYWORDS.WARN), desc("Next 'WARNING' Comment") },
                ['<leader>cwp'] = {
                    jump('prev', KEYWORDS.WARN),
                    desc("Previous 'WARNING' Comment"),
                },
                ['<leader>cnn'] = { jump('next', KEYWORDS.NOTE), desc("Next 'NOTE' Comment") },
                ['<leader>cnp'] = { jump('prev', KEYWORDS.NOTE), desc("Previous 'NOTE' Comment") },
                ['<leader>cl'] = { vim.cmd.TodoLocList, desc('Open Loclist For TODO Comments') },
                ['<leader>cT'] = {
                    function()
                        vim.cmd.TodoTelescope(('keywords=TODO,FIX cwd='):format(uv.cwd()))
                    end,
                    desc('Open TODO Telescope'),
                },
            },
        })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
