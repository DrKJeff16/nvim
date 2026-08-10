---@module 'lazy'

local ORG_PFX = vim.fn.expand('~/.org')

return { ---@type LazySpec
  'nvim-orgmode/orgmode',
  version = false,
  event = 'VeryLazy',
  cond = not require('user_api').check.in_console(),
  config = function()
    require('orgmode').setup({
      calendar_week_start_day = 0,
      org_adapt_indentation = true,
      org_agenda_files = ORG_PFX .. '/**/*',
      org_babel_default_header_args = { [':tangle'] = 'no', [':noweb'] = 'no' },
      org_default_notes_file = ORG_PFX .. '/default.org',
      org_ellipsis = '...',
      org_hide_emphasis_markers = false,
      org_hide_leading_stars = false,
      org_highlight_latex_and_related = 'native',
      org_startup_folded = 'showeverything',
      org_startup_indented = true,
      org_todo_keyword_faces = {
        WAITING = ':foreground blue :weight bold',
        DELEGATED = ':background #FFFFFF :underline on',
      },
      org_todo_keywords = { 'TODO', 'WAITING', '|', 'DONE', 'DELEGATED' },
      org_todo_repeat_to_state = nil,
      win_border = 'single',
      win_split_mode = 'auto',
    })

    require('user_api').config.keymaps.set({ n = { ['<leader>o'] = { group = '+Orgmode' } } })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
