vim.filetype.add({
  pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
})

return { ---@type vim.lsp.ClientConfig
  cmd = { 'hyprls', '--stdio' },
  filetypes = { 'hyprlang' },
  root_markers = { '.git' },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
