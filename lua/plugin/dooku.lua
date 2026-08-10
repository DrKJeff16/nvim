---@module 'lazy'
return { ---@type LazySpec
  'Zeioth/dooku.nvim',
  version = false,
  cond = not require('user_api').check.in_console(),
  opts = {
    auto_setup = true,
    browser_cmd = 'xdg-open',
    on_bufwrite_generate = false,
    on_generate_notification = true,
    on_generate_open = true,
    on_open_notification = true,
    project_root = { '.bzr', '.fslckout', '.git', '.github', '.hg', '.svn', '_FOSSIL_', '_darcs' },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
