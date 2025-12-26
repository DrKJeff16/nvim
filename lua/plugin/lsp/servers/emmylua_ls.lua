return { ---@type vim.lsp.ClientConfig
  cmd = { 'emmylua_ls' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.emmyrc.json', '.luacheckrc', '.git' },
  workspace_required = false,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
