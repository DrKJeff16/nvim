---@module 'lazy'
return { ---@type LazySpec
  'p00f/clangd_extensions.nvim',
  ft = { 'c', 'cpp' },
  dev = true,
  version = false,
  cond = require('user_api.check.exists').executable('clangd'),
  opts = {
    inlay_hints = { inline = true },
    ast = {
      role_icons = {
        type = '',
        declaration = '',
        expression = '',
        specifier = '',
        statement = '',
        ['template argument'] = '',
      },
      kind_icons = {
        Compound = '',
        Recovery = '',
        TranslationUnit = '',
        PackExpansion = '',
        TemplateTypeParm = '',
        TemplateTemplateParm = '',
        TemplateParamObject = '',
      },
      highlights = { detail = 'Comment' },
    },
    memory_usage = { border = 'double' },
    symbol_info = { border = 'single' },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
