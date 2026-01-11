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
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
