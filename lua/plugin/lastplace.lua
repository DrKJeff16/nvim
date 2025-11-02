---@module 'lazy'

---@type LazySpec
return {
    'DrKJeff16/lastplace.nvim',
    dev = true,
    version = false,
    config = function()
        require('lastplace').setup()
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
