---@module 'lazy'
return { ---@type LazySpec
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        bash = { 'shellcheck' },
        lua = { 'stylua', lsp_format = 'fallback' },
        python = { 'isort', 'autopep8', lsp_format = 'fallback' },
        sh = { 'shellcheck' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
