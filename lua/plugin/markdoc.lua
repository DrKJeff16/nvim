---@module 'lazy'

---@type LazySpec
return {
    'OXY2DEV/markdoc.nvim',
    version = false,
    cmd = { 'Doc' },
    config = function()
        require('markdoc').setup()
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
