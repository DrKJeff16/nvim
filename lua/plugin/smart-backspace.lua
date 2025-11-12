---@module 'lazy'

---@type LazySpec
return {
    'qwavies/smart-backspace.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    version = false,
    opts = { enabled = true, silent = true, disabled_filetypes = { 'py', 'hs', 'md', 'txt' } },
}
