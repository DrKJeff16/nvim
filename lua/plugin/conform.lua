---@module 'lazy'

return { ---@type LazySpec
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'autopep8' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
      },
      format_on_save = { timeout_ms = 1000, lsp_format = 'fallback' },
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      group = vim.api.nvim_create_augroup('Conform', { clear = true }),
      callback = function(args)
        require('conform').format({
          async = true,
          bufnr = args.buf,
          stop_after_first = true,
          undojoin = true,
        })
      end,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
