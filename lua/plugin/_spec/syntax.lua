---@module 'lazy'

---@type LazySpec[]
return {
    {
        'rhysd/vim-syntax-codeowners',
        lazy = false,
        version = false,
        init = require('config.util').flag_installed('codeowners'),
    },
    {
        'nvim-orgmode/orgmode',
        ft = 'org',
        version = false,
        config = require('config.util').require('plugin.orgmode'),
        cond = not require('user_api.check').in_console(),
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
