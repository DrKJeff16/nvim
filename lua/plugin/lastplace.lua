---@module 'lazy'
return { ---@type LazySpec
  'nxhung2304/lastplace.nvim',
  dev = true,
  version = false,
  config = function()
    require('lastplace').setup({
      center_on_jump = true,
      debug = false,
      ignore_buftypes = { 'help', 'nofile', 'quickfix', 'terminal' },
      ignore_filetypes = { '', 'COMMIT_EDITMSG', 'gitcommit', 'gitrebase', 'hgcommit', 'svn', 'xxd' },
      jump_only_if_not_visible = false,
      max_line = 0,
      min_lines = 10,
      open_folds = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
