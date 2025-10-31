---@module 'lazy'

---@type LazySpec
return {
    'fei6409/log-highlight.nvim',
    version = false,
    opts = {
        extension = 'log', ---@type string|string[]
        filename = { 'syslog' }, ---@type string|string[]
        pattern = { ---@type string|string[]
            -- Use `%` to escape special characters and match them literally.
            '%/var%/log%/.*',
            'console%-ramoops.*',
            'log.*%.txt',
            'logcat.*',
            '.*%.log',
        },
        keyword = { ---@type table<string, string|string[]>
            error = 'ERROR_MSG',
            warning = { 'WARN_X', 'WARN_Y' },
            info = { 'INFORMATION' },
            debug = {},
            pass = {},
        },
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
