---@module 'lazy'
return { ---@type LazySpec[]
  {
    'mason-org/mason.nvim',
    version = false,
    config = function()
      require('mason').setup({
        PATH = 'append', ---@type 'prepend'|'append'|'skip'
        github = { download_url_template = 'https://github.com/%s/releases/download/%s/%s' },
        install_root_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'mason'),
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 4,
        pip = { upgrade_pip = false, install_args = {} },
        providers = { 'mason.providers.registry-api', 'mason.providers.client' },
        registries = { 'github:mason-org/mason-registry' },
        ui = {
          backdrop = 60,
          check_outdated_packages_on_open = true,
          height = 0.9,
          icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
          keymaps = {
            apply_language_filter = '<C-f>',
            cancel_installation = '<C-c>',
            check_outdated_packages = 'C',
            check_package_version = 'c',
            install_package = 'i',
            toggle_help = 'g?',
            toggle_package_expand = '<CR>',
            toggle_package_install_log = '<CR>',
            uninstall_package = 'X',
            update_all_packages = 'U',
            update_package = 'u',
          },
          width = 0.8,
        },
      })

      local desc = require('user_api').maps.desc
      require('user_api').config.keymaps.set({
        n = {
          ['<leader>M'] = { group = '+Mason' },
          ['<leader>Mt'] = { vim.cmd.Mason, desc('Open Mason Window') },
          ['<leader>Mu'] = { vim.cmd.MasonUpdate, desc('Update Mason Packages') },
        },
      })
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    version = false,
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = { automatic_enable = true, ensure_installed = {} },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
