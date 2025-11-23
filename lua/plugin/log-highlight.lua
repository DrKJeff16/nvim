---@module 'lazy'

return { ---@type LazySpec
    'fei6409/log-highlight.nvim',
    version = false,
    opts = {
        extension = 'log',
        filename = { 'syslog' },
        pattern = { '%/var%/log%/.*', 'console%-ramoops.*', 'log.*%.txt', 'logcat.*', '.*%.log' },
        keyword = {
            error = 'ERROR_MSG',
            warning = { 'WARN_X', 'WARN_Y' },
            info = { 'INFORMATION' },
            debug = {},
            pass = {},
        },
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
