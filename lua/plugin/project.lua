---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/project.nvim',
  dev = true,
  version = false,
  config = function()
    local Project = require('project')
    Project.setup({
      custom_projects = {
        { path = Project.util.strip_slash('~/Documents'), name = 'Documents' },
        { path = Project.util.strip_slash('~/.bin'), name = 'Custom Scripts' },
        { path = Project.util.strip_slash('~/.env.d') },
        { path = Project.util.strip_slash('~/.config/bat'), name = 'bat Config' },
        { path = Project.util.strip_slash('~/.config/fastfetch'), name = 'fastfetch Config' },
        { path = Project.util.strip_slash('~/.config/ghostty'), name = 'ghostty Config' },
      },
      different_owners = { allow = true, notify = false },
      enable_autochdir = false,
      exclude_dirs = {
        '/tmp/*',
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
        '~/.steam/*',
        '~/.tmux/*',
        '~/.wine64/*',
        '~/Desktop/*',
        '~/Public/*',
        '~/Templates/*',
      },
      fzf_lua = { enabled = true, sort = 'newest', show = 'names' },
      history = { size = 70 },
      log = { enabled = true, logpath = vim.fn.stdpath('state'), max_size = 0.5 },
      lsp = { enabled = true, use_pattern_matching = true },
      manual_mode = false,
      picker = { enabled = true, sort = 'newest', show = 'names' },
      remove_missing_dirs = true,
      scope_chdir = 'tab',
      show_by_name = true,
      show_hidden = false,
      silent_chdir = true,
      snacks = { enabled = true, opts = { sort = 'newest', show = 'names', layout = 'vscode' }, show = 'names' },
      telescope = { prefer_file_browser = true, sort = 'newest', tilde = true },
    })

    local exists = require('user_api').check.module
    local desc = require('user_api').maps.desc
    local keyset = require('user_api').config.keymaps.set
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

    if exists('fzf-lua') and vim.g.project_fzf_lua_loaded == 1 then
      keyset({ n = { ['<leader>pf'] = { ':Project fzf-lua<CR>', desc('Fzf-Lua Picker') } } })
    end
    if exists('telescope.init') then
      require('telescope').load_extension('projects')
      if vim.g.project_telescope_loaded == 1 then
        keyset({ n = { ['<leader>pT'] = { ':Project telescope<CR>', desc('Telescope Picker') } } })
      end
    end
    if exists('snacks') and vim.g.project_snacks_loaded == 1 then
      keyset({ n = { ['<leader>pS'] = { ':Project snacks<CR>', desc('Snacks Picker') } } })
    end
    if exists('picker') and vim.g.project_picker_loaded == 1 then
      keyset({ n = { ['<leader>pP'] = { ':Project picker<CR>', desc('picker.nvim Picker') } } })
    end
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
