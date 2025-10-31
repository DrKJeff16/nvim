---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.icons',
    version = false,
    config = function()
        require('mini.icons').setup({
            style = 'glyph',
            default = { file = { glyph = '󰈤' } },
            extension = { lua = { hl = 'Special' } },
        })
        _G.MiniIcons.mock_nvim_web_devicons()
        _G.MiniIcons.tweak_lsp_kind('prepend')
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
