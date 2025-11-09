---@module 'lazy'

---@type LazySpec
return {
    'saghen/blink.indent',
    dev = true,
    event = 'VeryLazy', -- WARN: VERY IMPORTANT
    version = false,
    cond = not require('user_api.check').in_console(),
    opts = {},
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
