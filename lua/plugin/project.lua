---@module 'lazy'

return { ---@type LazySpec
    'DrKJeff16/project.nvim',
    dev = true,
    version = false,
    config = function()
        require('project').setup({
            log = { enabled = true, logpath = vim.fn.stdpath('state') },
            scope_chdir = 'tab',
            use_lsp = true,
            telescope = { prefer_file_browser = true, sort = 'newest' },
            fzf_lua = { enabled = true },
            exclude_dirs = {
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

        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = {
                ['<leader>p'] = { group = '+Project' },
                ['<leader>pC'] = { vim.cmd.ProjectConfig, desc('Toggle Config Window') },
                ['<leader>pH'] = { vim.cmd.ProjectHealth, desc('Run `:checkhealth project`') },
                ['<leader>pf'] = { vim.cmd.ProjectFzf, desc('Run Fzf-Lua') },
                ['<leader>ph'] = { vim.cmd.ProjectHistory, desc('Toggle History Window') },
                ['<leader>pl'] = { vim.cmd.ProjectLog, desc('Toggle Log Window') },
                ['<leader>pp'] = { vim.cmd.Project, desc('Open Project UI') },
                ['<leader>pr'] = { vim.cmd.ProjectRecents, desc('Select Recent Project') },
                ['<leader>ps'] = { vim.cmd.ProjectSession, desc('Select From Current Session') },
            },
        })

        if require('user_api.check.exists').module('telescope') then
            require('telescope').load_extension('projects')
            require('user_api.config').keymaps({
                n = {
                    ['<leader>pT'] = { vim.cmd.ProjectTelescope, desc('Run `:ProjectTelescope`') },
                },
            })
        end
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
