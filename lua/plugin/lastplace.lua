---@module 'lazy'

---@type LazySpec
return {
    'DrKJeff16/nvim-lastplace',
    dev = true,
    version = false,
    config = function()
        require('nvim-lastplace').setup()
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
