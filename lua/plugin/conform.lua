---@module 'lazy'
return { ---@type LazySpec
  'stevearc/conform.nvim',
  version = false,
  event = 'BufWritePre',
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function()
    require('conform').setup({
      default_format_opts = { lsp_format = 'fallback' },
      format_on_save = { timeout_ms = 1000 },
      formatters_by_ft = {
        bash = { 'shellcheck', stop_after_first = true },
        c = { 'clang-format', stop_after_first = true },
        cpp = { 'clang-format', stop_after_first = true },
        lua = { 'stylua', stop_after_first = true },
        markdown = { 'markdown-toc', stop_after_first = true },
        python = function(bufnr)
          local fmts = { 'isort', lsp_format = 'fallback' }
          if require('conform').get_formatter_info('ruff_format', bufnr).available then
            table.insert(fmts, 1, 'ruff_format')
          end
          return fmts
        end,
        yaml = { 'yamlfmt' },
      },
    })

    vim.api.nvim_create_user_command('FormatToggle', function(args)
      if args.bang then
        vim.g.disable_autoformat = not vim.g.disable_autoformat
      else
        vim.b.disable_autoformat = not vim.b.disable_autoformat
      end
    end, { desc = 'Toggle autoformat-on-save', bang = true })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
