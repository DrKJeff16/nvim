local MODSTR = 'config.lazy'
local stdpath = vim.fn.stdpath
local key_variant = require('config.util').key_variant

local LAZY_DATA = stdpath('data') .. '/lazy'
local LAZY_STATE = stdpath('state') .. '/lazy'
local LAZYPATH = LAZY_DATA .. '/lazy.nvim'
local README_PATH = LAZY_STATE .. '/readme'

---@class Config.Lazy
local M = {}

function M.bootstrap()
    if vim.g.lazy_bootstrapped == 1 then
        return
    end

    if not (vim.uv or vim.loop).fs_stat(LAZYPATH) then
        local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
        local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', lazyrepo, LAZYPATH })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { ('(%s): Failed to clone lazy.nvim:\n'):format(MODSTR), 'ErrorMsg' },
                { out, 'WarningMsg' },
                { '\nPress any key to exit...' },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    if not vim.o.runtimepath:find(LAZYPATH) then
        vim.o.runtimepath = ('%s,%s'):format(LAZYPATH, vim.o.runtimepath)
    end

    vim.g.lazy_bootstrapped = 1
end

function M.setup_keys()
    local desc = require('user_api.maps').desc
    local Lazy = require('lazy')
    require('user_api.config').keymaps({
        n = {
            ['<leader>L'] = { group = '+Lazy' },
            ['<leader>Le'] = { group = '+Edit Lazy File' },
            ['<leader>Lee'] = { key_variant('ed'), desc('Open `Lazy` File') },
            ['<leader>Les'] = { key_variant('split'), desc('Open `Lazy` File Horizontal Window') },
            ['<leader>Let'] = { key_variant('tabnew'), desc('Open `Lazy` File Tab') },
            ['<leader>Lev'] = { key_variant('vsplit'), desc('Open `Lazy`File Vertical Window') },
            ['<leader>Ll'] = { Lazy.show, desc('Show Lazy Home') },
            ['<leader>Ls'] = { Lazy.sync, desc('Sync Lazy Plugins') },
            ['<leader>Lx'] = { Lazy.clear, desc('Clear Lazy Plugins') },
            ['<leader>Lc'] = { Lazy.check, desc('Check Lazy Plugins') },
            ['<leader>Li'] = { Lazy.install, desc('Install Lazy Plugins') },
            ['<leader>Lh'] = { Lazy.health, desc('Run Lazy checkhealth') },
            ['<leader>vhL'] = { Lazy.health, desc('Run Lazy checkhealth') },
            ['<leader>L<CR>'] = { ':Lazy ', desc('Select `Lazy` Operation (Interactively)', false) },
            ['<leader>Lb'] = { ':Lazy build ', desc('Prompt To Build', false) },
            ['<leader>Lr'] = { ':Lazy reload ', desc('Prompt To Build', false) },
        },
    })
end

---Sets up `lazy.nvim`. Only runs once!
--- ---
---@param specs LazySpec[]
function M.setup(specs)
    M.bootstrap()

    require('lazy').setup({
        spec = specs or {
            { import = 'plugin.startuptime' },
            { import = 'plugin._spec.colorschemes' },
            { import = 'plugin._spec' },
            { import = 'plugin.notify' },
            { import = 'plugin.mini.icons' },
        },
        root = LAZY_DATA,
        defaults = { lazy = false, version = false },
        install = { colorscheme = { 'habamax' }, missing = true },
        dev = { path = '~/Projects/nvim', patterns = {}, fallback = true },
        change_detection = {
            enabled = true,
            notify = require('user_api.distro.archlinux').validate(),
        },
        performance = {
            reset_packpath = true,
            rtp = {
                reset = true,
                disabled_plugins = {
                    -- 'gzip',
                    -- 'matchit',
                    -- 'matchparen',
                    'netrwPlugin',
                    -- 'tarPlugin',
                    'tohtml',
                    'tutor',
                    -- 'zipPlugin',
                },
            },
        },
        rocks = {
            enabled = require('config.util').luarocks_check(),
            root = stdpath('data') .. '/lazy-rocks',
            server = 'https://nvim-neorocks.github.io/rocks-binaries/',
        },
        pkg = {
            enabled = true,
            cache = LAZY_STATE .. '/pkg-cache.lua',
            versions = true,
            sources = (function()
                if require('config.util').luarocks_check() then
                    return { 'lazy', 'packspec' }
                end
                return { 'lazy', 'packspec', 'rockspec' }
            end)(),
        },
        checker = {
            enabled = not require('user_api.distro.termux').validate(),
            notify = require('user_api.distro.archlinux').validate(),
            frequency = 600,
            check_pinned = false,
        },
        ui = {
            backdrop = not require('user_api.check').in_console() and 60 or 100,
            border = 'double',
            title = 'L        A        Z        Y',
            title_pos = 'center',
            wrap = true,
            pills = true,
        },
        readme = {
            enabled = false,
            root = README_PATH,
            files = { 'README.md', 'lua/**/README.md' },
            skip_if_doc_exists = true,
        },
        state = LAZY_STATE .. '/state.json',
        profiling = { loader = true, require = true },
    })

    M.setup_keys()
end

function M.colorschemes()
    if require('user_api.check.exists').module('plugin.colorschemes') then
        return require('plugin.colorschemes')
    end
end

function M.lsp()
    if require('user_api.check.exists').module('plugin.lsp') then
        return require('plugin.lsp')
    end
end

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
