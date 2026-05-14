---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/project.nvim',
  dev = true,
  version = false,
  config = function()
    require('project').setup({
      custom_projects = {
        { path = vim.fn.expand('~/Documents'), name = 'Documents' },
        { path = vim.fn.expand('~/.bin'), name = 'Custom Scripts' },
        { path = vim.fn.expand('~/.env.d') },
      },
      log = { enabled = true, logpath = vim.fn.stdpath('state'), max_size = 0.5 },
      snacks = { enabled = true, opts = { sort = 'newest', show = 'names' } },
      different_owners = { allow = true, notify = false },
      telescope = { prefer_file_browser = true, sort = 'newest', tilde = true },
      fzf_lua = { enabled = true, sort = 'newest', show = 'names' },
      picker = { enabled = true, sort = 'newest', show = 'names' },
      lsp = { enabled = true },
      scope_chdir = 'tab',
      show_by_name = true,
      enable_autochdir = false,
      history = { size = 70 },
      manual_mode = false,
      remove_missing_dirs = true,
      show_hidden = false,
      silent_chdir = true,
      exclude_dirs = {
        '/tmp',
        '/tmp/*',
        '/usr',
        '/usr/*',
        '~/.build/*',
        '~/.cache/*',
        '~/.cargo/*',
        '~/.conda/*',
        '~/.gnupg/*',
        '~/.local/*',
        '~/.luarocks/*',
        '~/.rustup/*',
        '~/.ssh/*',
        '~/.tmux/*',
        '~/.wine64/*',
        '~/Desktop/*',
        '~/Public/*',
        '~/Templates/*',
      },
    })

    local desc = require('user_api.maps').new_desc
    local keyset = require('user_api.config.keymaps').set
    keyset({
      n = {
        ['<leader>p'] = { group = '+Project' },
        ['<leader>pR'] = {
          function()
            vim.cmd.Project({ args = { 'history', 'rename' } })
          end,
          desc('Rename a Project'),
        },
        ['<leader>pC'] = { ':Project config<CR>', desc('Toggle Config Window') },
        ['<leader>pH'] = { ':Project health<CR>', desc('Run `:checkhealth project`') },
        ['<leader>pa'] = { ':Project add<CR>', desc('Add New Project') },
        ['<leader>pd'] = { ':Project delete<CR>', desc('Delete Existing Project') },
        ['<leader>ph'] = { ':Project history<CR>', desc('Toggle History Window') },
        ['<leader>pl'] = { ':Project log<CR>', desc('Toggle Log Window') },
        ['<leader>pp'] = { vim.cmd.Project, desc('Open Project UI') },
        ['<leader>pr'] = { ':Project recents<CR>', desc('Recent Projects') },
        ['<leader>ps'] = { ':Project session<CR>', desc('Session') },
      },
    })

    if require('user_api.check').module('fzf-lua') and vim.cmd.ProjectFzf and vim.is_callable(vim.cmd.ProjectFzf) then
      keyset({ n = { ['<leader>pf'] = { vim.cmd.ProjectFzf, desc('Fzf-Lua Picker') } } })
    end
    if
      require('user_api.check').module('telescope')
      and vim.cmd.ProjectTelescope
      and vim.is_callable(vim.cmd.ProjectTelescope)
    then
      require('telescope').load_extension('projects')
      keyset({ n = { ['<leader>pT'] = { vim.cmd.ProjectTelescope, desc('Telescope Picker') } } })
    end
    if
      require('user_api.check').module('snacks')
      and vim.cmd.ProjectSnacks
      and vim.is_callable(vim.cmd.ProjectSnacks)
    then
      keyset({ n = { ['<leader>pS'] = { vim.cmd.ProjectSnacks, desc('Snacks Picker') } } })
    end
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
