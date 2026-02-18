---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.icons',
  version = false,
  config = function()
    require('mini.icons').setup({ style = 'glyph' })
    _G.MiniIcons.mock_nvim_web_devicons()
    _G.MiniIcons.tweak_lsp_kind('prepend')
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
