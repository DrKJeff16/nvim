---@module 'lazy'

return { ---@type LazySpec
    'ThePrimeagen/refactoring.nvim',
    lazy = false,
    version = false,
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    config = function()
        require('refactoring').setup({
            prompt_func_return_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
            show_success_message = false,
        })
        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = {
                ['<leader>r'] = { group = '+Refactoring' },
                ['<leader>rB'] = {
                    ':Refactor extract_block_to_file<CR>',
                    desc('Extlarn Block To File'),
                },
                ['<leader>rb'] = { ':Refactor extract_block<CR>', desc('Extract Block') },
                ['<leader>ri'] = { ':Refactor inline_var<CR>', desc('Inline Var') },
                ['<leader>rI'] = { ':Refactor inline_func<CR>', desc('Inline Func') },
            },
            x = {
                ['<leader>r'] = { group = '+Refactoring' },
                ['<leader>re'] = { ':Refactor extract ', desc('Extract', false) },
                ['<leader>rf'] = { ':Refactor extract_to_file ', desc('Extract To File', false) },
                ['<leader>ri'] = { ':Refactor inline_var<CR>', desc('Inline Var') },
                ['<leader>rv'] = { ':Refactor extract_var ', desc('Extract Var', false) },
            },
        })

        vim.keymap.set({ 'n', 'x' }, '<leader>re', function()
            return require('refactoring').refactor('Extract Function')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>rf', function()
            return require('refactoring').refactor('Extract Function To File')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>rv', function()
            return require('refactoring').refactor('Extract Variable')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>rI', function()
            return require('refactoring').refactor('Inline Function')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>ri', function()
            return require('refactoring').refactor('Inline Variable')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>rbb', function()
            return require('refactoring').refactor('Extract Block')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>rbf', function()
            return require('refactoring').refactor('Extract Block To File')
        end, { expr = true })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
