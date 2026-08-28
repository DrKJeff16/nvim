---@module 'lazy'
return { ---@type LazySpec
  'kdheepak/lazygit.nvim',
  cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
  version = false,
  dependencies = { { 'DrKJeff16/plenary.nvim', dev = true } },
  cond = require('user_api').check.executable({ 'git', 'lazygit' }),
  config = function()
    local g_vars = {
      floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
      floating_window_scaling_factor = 0.9,
      floating_window_use_plenary = 1,
      floating_window_winblend = 0,
      use_custom_config_file_path = 0,
      use_neovim_remote = 0,
    }
    for k, v in pairs(g_vars) do
      vim.g['lazygit_' .. k] = v
    end

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = {
        ['<leader>Gl'] = { group = '+LazyGit' },
        ['<leader>GlC'] = { vim.cmd.LazyGitConfig, desc('Config') },
        ['<leader>GlF'] = { vim.cmdLazyGitFilter, desc('Open Project Commits on a Floating Window') },
        ['<leader>Glc'] = { vim.cmd.LazyGitCurrentFile, desc('Run on Current File') },
        ['<leader>Glf'] = { vim.cmd.LazyGitFilterCurrentFile, desc('Filter Current File') },
        ['<leader>Glg'] = { vim.cmd.LazyGit, desc('Run LazyGit') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
