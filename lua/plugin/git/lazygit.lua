---@module 'lazy'
return { ---@type LazySpec
  'kdheepak/lazygit.nvim',
  cmd = { 'LazyGit' },
  version = false,
  cond = require('user_api.check.exists').executable({ 'git', 'lazygit' }),
  config = function()
    local g_vars = {
      floating_window_winblend = 0,
      floating_window_scaling_factor = 1.0,
      floating_window_use_plenary = 0,
      use_neovim_remote = 0,
      use_custom_config_file_path = 0,
      floating_window_border_chars = {
        '╭',
        '─',
        '╮',
        '│',
        '╯',
        '─',
        '╰',
        '│',
      },
    }
    for k, v in pairs(g_vars) do
      vim.g['lazygit_' .. k] = v
    end

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
      n = {
        ['<leader>G'] = { group = '+Git' },
        ['<leader>Gl'] = { group = '+LazyGit' },
        ['<leader>GlC'] = { vim.cmd.LazyGitConfig, desc("LazyGit's Config") },
        ['<leader>GlF'] = { vim.cmdLazyGitFilter, desc('Open Project Commits In Float') },
        ['<leader>Glc'] = { vim.cmd.LazyGitCurrentFile, desc('LazyGit On Current File') },
        ['<leader>Glf'] = { vim.cmd.LazyGitFilterCurrentFile, desc("LazyGit's Config") },
        ['<leader>Glg'] = { vim.cmd.LazyGit, desc('Run LazyGit') },
      },
    })

    local group = vim.api.nvim_create_augroup('User.LazyGit', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
      pattern = '*',
      group = group,
      callback = function()
        require('lazygit.utils').project_root_dir()
      end,
    })
    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*',
      group = group,
      callback = function()
        if require('user_api.util').ft_get() ~= 'lazygit' and not vim.v.event.status then
          vim.fn.execute('bdelete! ' .. vim.fn.expand('<abuf>'), 'silent!')
        end
      end,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
