---@module 'lazy'
return { ---@type LazySpec
  'stevearc/conform.nvim',
  version = false,
  config = function()
    require('conform').setup({
      format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
      formatters_by_ft = {
        lua = { 'stylua', lsp_format = 'fallback' },
        python = { 'isort', 'yapf', lsp_format = 'fallback' },
        yaml = { 'yamlfmt' },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
