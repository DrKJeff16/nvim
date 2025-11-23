---@module 'lazy'

return { ---@type LazySpec
    'qwavies/smart-backspace.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    version = false,
    opts = { enabled = true, silent = true, disabled_filetypes = { 'py', 'hs', 'md', 'txt' } },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
