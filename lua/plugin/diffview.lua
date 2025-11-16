---@module 'lazy'

return { ---@type LazySpec
    'sindrets/diffview.nvim',
    cmd = {
        'DiffviewToggleFiles',
        'DiffviewOpen',
        'DiffviewClose',
        'DiffviewFileHistory',
        'DiffviewFocusFiles',
        'DiffviewLog',
        'DiffviewRefresh',
    },
    version = false,
    cond = require('user_api.check.exists').executable('git'),
    opts = {},
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
