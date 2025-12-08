---@module 'lazy'

return { ---@type LazySpec
    'saghen/blink.indent',
    version = false,
    cond = not require('user_api.check').in_console(),
    opts = {},
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
