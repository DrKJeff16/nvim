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
                ['<leader>pp'] = { vim.cmd.Project, desc('Open Project UI') },
                ['<leader>pC'] = { vim.cmd.ProjectConfig, desc('Print Project Config') },
                ['<leader>pr'] = { vim.cmd.ProjectRecents, desc('Print Recent Projects') },
                ['<leader>pl'] = { vim.cmd.ProjectLog, desc('Open Project Log Window') },
                ['<leader>ph'] = { vim.cmd.ProjectHealth, desc('Run `:checkhealth project`') },
                ['<leader>pf'] = { vim.cmd.ProjectFzf, desc('Run Fzf-Lua') },
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
