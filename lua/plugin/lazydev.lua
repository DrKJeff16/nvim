---@module 'lazy'
return { ---@type LazySpec
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
      library = { ---@type lazydev.Library.spec[]
        { path = '${3rd}/luv/library', words = { 'vim%.uv', 'vim%.loop' } },
        { path = 'snacks.nvim', mods = { 'snacks' } },
        { path = 'wezterm-types', mods = { 'wezterm' } },
        { path = 'project.nvim', mods = { 'project' } },
      },
      enabled = function(root_dir) ---@type boolean|(fun(root_dir: string): boolean)
        local fs_stat = (vim.uv or vim.loop).fs_stat
        return not (fs_stat(root_dir .. '/.luarc.json') or fs_stat(root_dir .. '/luarc.json'))
      end,
      integrations = { lspconfig = true, cmp = true, coq = false },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
