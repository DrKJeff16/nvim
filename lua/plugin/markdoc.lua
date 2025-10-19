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
