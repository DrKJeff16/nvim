---@module 'lazy'

return { ---@type LazySpec
    'melmass/echo.nvim',
    version = false,
    cond = not require('user_api.check').in_console(),
    opts = { demo = true },
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
