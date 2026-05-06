return { ---@type vim.lsp.ClientConfig
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start(
      { 'ruby-lsp' },
      dispatchers,
      config and config.root_dir and { cwd = config.cmd_cwd or config.root_dir }
    )
  end,
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  init_options = { formatter = 'auto' },
  ---@param client vim.lsp.Client
  ---@param config vim.lsp.ClientConfig
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.config.cmd_cwd == config.cmd_cwd
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
