---@module 'lazy'
return { ---@type LazySpec
  'onsails/lspkind.nvim',
  lazy = false,
  version = false,
  config = function()
    require('lspkind').init({
      mode = 'symbol_text',
      preset = 'codicons',
      symbol_map = {
        Text = '󰉿',
        Method = '󰆧',
        Function = '󰊕',
        Constructor = '',
        Field = '󰜢',
        Variable = '󰀫',
        Class = '󰠱',
        Interface = '',
        Module = '',
        Property = '󰜢',
        Unit = '󰑭',
        Value = '󰎠',
        Enum = '',
        Keyword = '󰌋',
        Snippet = '',
        Color = '󰏘',
        File = '󰈙',
        Reference = '󰈇',
        Folder = '󰉋',
        EnumMember = '',
        Constant = '󰏿',
        Struct = '󰙅',
        Event = '',
        Operator = '󰆕',
        TypeParameter = '',
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
