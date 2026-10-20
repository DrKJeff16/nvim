---@module 'lazy'
return { ---@type LazySpec
  url = 'https://git.sr.ht/~chinmay/clangd_extensions.nvim',
  dev = true,
  ft = { 'c', 'cpp' },
  version = false,
  cond = require('user_api').check.executable('clangd'),
  opts = {
    ast = {
      highlights = { detail = 'Comment' },
      kind_icons = {
        Compound = '',
        PackExpansion = '',
        Recovery = '',
        TemplateParamObject = '',
        TemplateTemplateParm = '',
        TemplateTypeParm = '',
        TranslationUnit = '',
      },
      role_icons = {
        ['template argument'] = '',
        declaration = '',
        expression = '',
        specifier = '',
        statement = '',
        type = '',
      },
    },
    inlay_hints = { inline = true },
    memory_usage = { border = 'double' },
    symbol_info = { border = 'single' },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
