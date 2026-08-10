---@module 'lazy'
return { ---@type LazySpec
  'folke/lazydev.nvim',
  ft = 'lua',
  event = 'LspAttach',
  version = false,
  dependencies = { { 'DrKJeff16/wezterm-types', lazy = true, dev = true, version = false } },
  cond = require('user_api').check.executable('lua-language-server'),
  config = function()
    local fs_stat = vim.uv.fs_stat
    require('lazydev').setup({
      enabled = function(root_dir) ---@type boolean|(fun(root_dir: string): boolean)
        return not (
          fs_stat(vim.fs.joinpath(root_dir, '.luarc.json')) or fs_stat(vim.fs.joinpath(root_dir, 'luarc.json'))
        )
      end,
      integrations = { lspconfig = true, cmp = true, coq = false },
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv', 'vim%.loop' } },
        { path = 'project.nvim', mods = { 'project' } },
        { path = 'snacks.nvim', mods = { 'snacks' } },
        { path = 'wezterm-types', mods = { 'wezterm' } },
      },
      runtime = vim.env.VIMRUNTIME,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
