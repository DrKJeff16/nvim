---@module 'lazy'

return { ---@type LazySpec
    'stephansama/fzf-nerdfont.nvim',
    dev = true,
    cmd = 'FzfNerdfont',
    build = ':FzfNerdfont generate',
    version = false,
    dependencies = { 'ibhagwan/fzf-lua' },
    opts = {},
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
