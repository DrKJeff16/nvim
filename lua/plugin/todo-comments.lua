---@module 'lazy'

local ERROR = vim.log.levels.ERROR

---@param direction 'next'|'prev'
---@param keywords string[]
---@return function
local function jump(direction, keywords)
  require('user_api').check.validate({
    direction = { direction, { 'string' } },
    keywords = { keywords, { 'table' } },
  })
  if not vim.list_contains({ 'next', 'prev' }, direction) then
    error(('Invalid direction `%s`!'):format(direction), ERROR)
  end
  if vim.tbl_isempty(keywords) then
    error('No available keywords!', ERROR)
  end

  local direction_map = {
    next = require('todo-comments').jump_next,
    prev = require('todo-comments').jump_prev,
  }

  return direction_map[direction]
end

return { ---@type LazySpec
  'folke/todo-comments.nvim',
  version = false,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cond = require('user_api').check.executable({ 'rg', 'tree-sitter' }) and not require('user_api').check.in_console(),
  config = function()
    require('todo-comments').setup({
      colors = {
        default = { 'Identifier', '#7C3AED' },
        error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
        hint = { 'DiagnosticHint', '#10B981' },
        info = { 'DiagnosticInfo', '#2563EB' },
        test = { 'Identifier', '#FF00FF' },
        warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
      },
      gui_style = { bg = 'BOLD', fg = 'NONE' },
      highlight = {
        after = 'fg',
        before = '',
        comments_only = true,
        exclude = {},
        keyword = 'wide',
        max_line_len = 250,
        multiline = true,
        multiline_context = 1,
        multiline_pattern = '^.',
        pattern = [[.*<(KEYWORDS)\s*:]],
      },
      keywords = {
        FIX = {
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'TOFIX', 'SOLVE', 'TOSOLVE', 'SOLVEIT' },
          color = 'error',
          icon = ' ',
        },
        HACK = { alt = { 'TRICK', 'SOLUTION', 'ADHOC', 'SOLVED' }, color = 'warning', icon = ' ' },
        NOTE = { alt = { 'INFO', 'MINDTHIS', 'TONOTE', 'WATCH' }, color = 'hint', icon = ' ' },
        PERF = { alt = { 'OPTIM', 'OPTIMIZED', 'PERFORMANCE' }, color = 'info', icon = ' ' },
        TEST = { alt = { 'TESTING', 'PASSED', 'FAILED' }, color = 'test', icon = '⏲ ' },
        TITLE = {
          alt = { 'SECTION', 'BLOCK', 'CODESECTION', 'SECTIONTITLE', 'CODETITLE' },
          color = '#00886d',
          icon = '! ',
        },
        TODO = { alt = { 'PENDING', 'MISSING' }, color = 'info', icon = ' ' },
        WARN = { alt = { 'ATTENTION', 'ISSUE', 'PROBLEM', 'WARNING', 'XXX' }, color = 'warning', icon = ' ' },
      },
      merge_keywords = true,
      search = {
        args = { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column' },
        command = 'rg',
        pattern = [[\b(KEYWORDS):]],
      },
      sign_priority = 8,
      signs = true,
    })

    local KEYWORDS = { ---@class TODOKeywords
      FIX = { 'FIX', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'TOFIX', 'SOLVE', 'TOSOLVE', 'SOLVEIT' },
      HACK = { 'HACK', 'TRICK', 'SOLUTION', 'ADHOC', 'SOLVED' },
      NOTE = { 'NOTE', 'INFO', 'MINDTHIS', 'TONOTE', 'WATCH' },
      PERF = { 'PERF', 'OPTIM', 'OPTIMIZED', 'PERFORMANCE' },
      TEST = { 'TEST', 'TESTING', 'PASSED', 'FAILED' },
      TITLE = { 'TITLE', 'SECTION', 'BLOCK', 'CODESECTION', 'SECTIONTITLE', 'CODETITLE' },
      TODO = { 'TODO', 'PENDING', 'MISSING' },
      WARN = { 'WARN', 'ATTENTION', 'ISSUE', 'PROBLEM', 'WARNING', 'XXX' },
    }

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = {
        ['<leader>c'] = { group = '+Comments' },
        ['<leader>cf'] = { group = "+'FIX'" },
        ['<leader>cn'] = { group = "+'NOTE'" },
        ['<leader>ct'] = { group = "+'TODO'" },
        ['<leader>cw'] = { group = "+'WARNING'" },
        ['<leader>cT'] = {
          function()
            vim.cmd.TodoTelescope({ args = { 'keywords=TODO,FIX', ('cwd=%s'):format(vim.uv.cwd()) } })
          end,
          desc('Open TODO Telescope'),
        },
        ['<leader>cfn'] = { jump('next', KEYWORDS.FIX), desc('Next `FIX` Comment') },
        ['<leader>cfp'] = { jump('prev', KEYWORDS.FIX), desc('Previous `FIX` Comment') },
        ['<leader>cl'] = { vim.cmd.TodoLocList, desc('Open Loclist For TODO Comments') },
        ['<leader>cnn'] = { jump('next', KEYWORDS.NOTE), desc('Next `NOTE` Comment') },
        ['<leader>cnp'] = { jump('prev', KEYWORDS.NOTE), desc('Previous `NOTE` Comment') },
        ['<leader>ctn'] = { jump('next', KEYWORDS.TODO), desc('Next `TODO` Comment') },
        ['<leader>ctp'] = { jump('prev', KEYWORDS.TODO), desc('Previous `TODO` Comment') },
        ['<leader>cwn'] = { jump('next', KEYWORDS.WARN), desc('Next `WARNING` Comment') },
        ['<leader>cwp'] = { jump('prev', KEYWORDS.WARN), desc('Previous `WARNING` Comment') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
