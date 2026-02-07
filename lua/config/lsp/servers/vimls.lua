return { ---@type vim.lsp.ClientConfig
  cmd = { 'vim-language-server', '--stdio' },
  filetypes = { 'vim' },
  init_options = {
    diagnostic = { enable = true },
    indexes = {
      count = 3,
      gap = 100,
      projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
      runtimepath = true,
    },
    isNeovim = true,
    iskeyword = '@,48-57,_,192-255,-#',
    runtimepath = '',
    suggest = { fromRuntimepath = true, fromVimruntime = true },
    vimruntime = '',
  },
  root_markers = { '.git' },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
