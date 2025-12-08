---@module 'lazy'

return { ---@type LazySpec[]
    {
        'mason-org/mason.nvim',
        version = false,
        opts = {
            install_root_dir = vim.fn.stdpath('data') .. '/mason',
            PATH = 'prepend', ---@type 'prepend'|'append'|'skip'
            log_level = vim.log.levels.INFO,
            max_concurrent_installers = 4,
            registries = { 'github:mason-org/mason-registry' },
            providers = { 'mason.providers.registry-api', 'mason.providers.client' },
            github = { download_url_template = 'https://github.com/%s/releases/download/%s/%s' },
            pip = { upgrade_pip = false, install_args = {} },
            ui = {
                check_outdated_packages_on_open = true,
                border = nil,
                backdrop = 60,
                width = 0.8,
                height = 0.9,
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
                keymaps = {
                    toggle_package_expand = '<CR>',
                    install_package = 'i',
                    update_package = 'u',
                    check_package_version = 'c',
                    update_all_packages = 'U',
                    check_outdated_packages = 'C',
                    uninstall_package = 'X',
                    cancel_installation = '<C-c>',
                    apply_language_filter = '<C-f>',
                    toggle_package_install_log = '<CR>',
                    toggle_help = 'g?',
                },
            },
        },
    },
    {
        'mason-org/mason-lspconfig.nvim',
        version = false,
        dependencies = { 'neovim/nvim-lspconfig' },
        opts = { automatic_enable = false, ensure_installed = { 'lua_ls' } },
    },
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
