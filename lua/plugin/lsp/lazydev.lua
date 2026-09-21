---@module 'lazy'
return { ---@type LazySpec
  'folke/lazydev.nvim',
  ft = 'lua',
  version = false,
  dependencies = { { 'DrKJeff16/wezterm-types', lazy = true, dev = true, version = false } },
  cond = require('user_api').check.executable('lua-language-server'),
  config = function()
    require('lazydev').setup({
      enabled = function(root_dir) ---@param root_dir string
        local uv = vim.uv or vim.loop
        return not (
          uv.fs_stat(vim.fs.joinpath(root_dir, '.luarc.json'))
          or uv.fs_stat(vim.fs.joinpath(root_dir, 'luarc.json'))
        )
      end,
      integrations = { lspconfig = true, cmp = true, coq = false },
      library = {
        { path = vim.fs.joinpath(vim.env.VIMRUNTIME, 'lua', 'vim'), words = { 'vim' } },
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'project.nvim', mods = { 'project' } },
        { path = 'which-colorscheme.nvim', mods = { 'which-colorscheme' } },
        { path = 'shebang.nvim', mods = { 'shebang' } },
        { path = 'boolean-toggle.nvim', mods = { 'boolean-toggle' } },
        { path = 'snacks.nvim', mods = { 'snacks' } },
        { path = 'wezterm-types', mods = { 'wezterm' } },
      },
      runtime = vim.env.VIMRUNTIME,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
