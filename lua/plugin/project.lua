---@module 'lazy'

---@type LazySpec
return {
    'DrKJeff16/project.nvim',
    dev = true,
    version = false,
    init = function()
        vim.g.project_lsp_nowarn = 1
    end,
    config = function()
        require('project').setup({
            log = { enabled = true, logpath = vim.fn.stdpath('state') },
            scope_chdir = 'tab',
            detection_methods = { 'pattern' },
            telescope = { enabled = false, prefer_file_browser = true },
            show_hidden = true,
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
                ['<leader>pf'] = { require('project').run_fzf_lua, desc('Run Fzf-Lua') },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
