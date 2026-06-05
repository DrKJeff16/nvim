---@module 'lazy'
return { ---@type LazySpec
  'nvim-neorg/neorg',
  lazy = false,
  version = false,
  build = not require('user_api').check.executable('luarocks') and false or function()
    for _, pkg in ipairs({
      'luarocks-build-treesitter-parser',
      'luarocks-build-treesitter-parser-cpp',
      'tree-sitter-norg',
      'tree-sitter-norg-meta',
    }) do
      vim.system({ 'luarocks', 'install', '--local', pkg }):wait(60000)
    end
  end,
  dependencies = { 'nvim-neorg/lua-utils.nvim', '3rd/image.nvim' },
  config = function()
    require('neorg').setup({
      load = {
        ['core.autocommands'] = {},
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
        ['core.presenter'] = { config = { zen_mode = 'zen-mode' } },
        ['core.qol.toc'] = {},
        ['core.queries.native'] = {},
        ['core.summary'] = {},
        ['core.tangle'] = {},
        ['core.text-objects'] = {},
        ['core.ui'] = {},
        ['core.ui.calendar'] = {},
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
