---@module 'lazy'

return { ---@type LazySpec
  'Zeioth/dooku.nvim',
  version = false,
  cond = not require('user_api.check').in_console(),
  opts = {
    project_root = { '.git', '.hg', '.svn', '.bzr', '_darcs', '_FOSSIL_', '.fslckout' },
    browser_cmd = 'xdg-open',
    on_bufwrite_generate = false,
    on_generate_open = true,
    auto_setup = true,
    on_generate_notification = true,
    on_open_notification = true,
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
