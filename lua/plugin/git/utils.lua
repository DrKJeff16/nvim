---@module 'lazy'
return { ---@type LazySpec
  'BibekBhusal0/nvim-git-utils',
  dev = true,
  version = false,
  cmd = {
    'GitAddCommit',
    'GitCommit',
    'GitChangeLastCommit',
    'GitChanges',
    'DiffviewCompareBranchesTelescope',
    'DiffviewFileHistoryTelescope',
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim',
    'sindrets/diffview.nvim',
  },
  cond = require('user_api.check.exists').executable('git'),
  config = function()
    require('nvim-git-utils').setup({
      log = { enabled = true, icon = '' },
      commit_input = { max_length = 72, format_message = nil, hints = true },
    })

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
      n = {
        ['<leader>GcC'] = { vim.cmd.GitCommit, desc('Commit') },
        ['<leader>Gcc'] = { vim.cmd.GitAddCommit, desc('Add and commit') },
        ['<leader>Gcl'] = { vim.cmd.GitChangeLastCommit, desc('Change last commit message') },
        ['<leader>Gg'] = { vim.cmd.GitChanges, desc('Git open changed files') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
