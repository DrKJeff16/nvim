---@module 'lazy'

return { ---@type LazySpec
    'stevearc/conform.nvim',
    config = function()
        require('conform').setup({
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'isort', 'autopep8' },
            },
            format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
        })

        vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('Conform', { clear = true }),
            callback = function(args)
                require('conform').format({ bufnr = args.buf })
            end,
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
