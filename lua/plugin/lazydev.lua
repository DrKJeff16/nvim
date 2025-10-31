---@module 'lazy'

---@type LazySpec
return {
    'folke/lazydev.nvim',
    ft = { 'lua' },
    version = false,
    dependencies = {
        { 'DrKJeff16/wezterm-types', lazy = true, dev = true, version = false },
    },
    cond = require('user_api.check.exists').executable('lua-language-server'),
    config = function()
        require('lazydev').setup({
            runtime = vim.env.VIMRUNTIME,
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                { path = 'snacks.nvim', words = { 'Snacks' } },
                { path = 'wezterm-types', mods = { 'wezterm' } },
            },
            enabled = function(root_dir) ---@type boolean|(fun(root_dir: string): boolean)
                local fs_stat = (vim.uv or vim.loop).fs_stat
                return not (
                    fs_stat(root_dir .. '/.luarc.json') or fs_stat(root_dir .. '/luarc.json')
                )
            end,
            integrations = { lspconfig = true, cmp = true, coq = false },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
