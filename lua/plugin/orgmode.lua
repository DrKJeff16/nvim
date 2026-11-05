---@module 'lazy'

local ORG_PFX = vim.fn.expand('~/.org')

return { ---@type LazySpec[]
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    version = false,
    config = function()
      require('orgmode').setup({
        calendar_week_start_day = 0,
        org_adapt_indentation = true,
        org_agenda_files = vim.fs.joinpath(ORG_PFX, '**', '*'),
        org_babel_default_header_args = { [':noweb'] = 'no', [':tangle'] = 'no' },
        org_default_notes_file = vim.fs.joinpath(ORG_PFX, 'default.org'),
        org_ellipsis = '...',
        org_hide_emphasis_markers = false,
        org_hide_leading_stars = false,
        org_highlight_latex_and_related = 'native',
        org_startup_folded = 'showeverything',
        org_startup_indented = true,
        org_todo_keywords = { 'TODO', 'WAITING', '|', 'DONE', 'DELEGATED' },
        win_border = 'double',
        win_split_mode = 'auto',
      })

      require('user_api').config.keymaps.set({ n = { ['<leader>o'] = { group = '+Orgmode' } } })

      vim.lsp.enable('org')
    end,
  },
  {
    'kristijanhusak/org-lsp',
    event = 'VeryLazy',
    version = false,
    build = ':OrgLspDownload',
    config = function()
      require('org-lsp').setup({
        calendar_win_mode = 'cursor',
        settings = {
          org_agenda_custom_commands = {
            {
              blocks = {
                { type = 'agenda', settings = { org_agenda_span = 'day' } },
                { type = 'todo', match = 'WAIT', header = 'Waiting for' },
              },
              description = 'Today, then what is waiting',
              key = 'd',
            },
          },
          org_agenda_files = { '~/.org', '~/.org/notes/**/*.org' },
          org_capture_templates = {
            {
              description = 'Task',
              key = 't',
              target = { 'file+headline', '~/org/inbox.org', 'Tasks' },
              template = '* TODO %?\n  %U',
            },
          },
          org_log_done = 'time',
          org_todo_keywords = { 'TODO(t)', 'NEXT(n)', 'WAIT(w@/!)', '|', 'DONE(d!)', 'CANCELLED(c@)' },
        },
        win_split_mode = 'vsplit',
      })
    end,
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
