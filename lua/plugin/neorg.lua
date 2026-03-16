---@module 'lazy'
return { ---@type LazySpec
  'nvim-neorg/neorg',
  lazy = false,
  version = false,
  dependencies = { 'nvim-neorg/lua-utils.nvim', '3rd/image.nvim' },
  config = function()
    require('neorg').setup({
      load = {
        ['core.autocommands'] = {},
        ['core.completion'] = { config = { engine = 'nvim-cmp' } },
        ['core.concealer'] = {},
        ['core.defaults'] = {},
        ['core.dirman'] = {},
        ['core.export'] = {},
        ['core.export.html'] = {},
        ['core.export.markdown'] = {},
        ['core.fs'] = {},
        ['core.highlights'] = {},
        ['core.integrations.treesitter'] = {},
        ['core.itero'] = {},
        ['core.journal'] = {},
        ['core.latex.renderer'] = {},
        ['core.presenter'] = { config = { zen_mode = 'zen-mode' } },
        ['core.qol.toc'] = {},
        ['core.queries.native'] = {},
        ['core.summary'] = {},
        ['core.tangle'] = {},
        ['core.text-objects'] = {},
        ['core.todo-introspector'] = {},
        ['core.ui'] = {},
        ['core.ui.calendar'] = {},
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
