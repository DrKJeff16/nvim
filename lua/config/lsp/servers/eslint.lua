local base_on_attach = vim.lsp.config.eslint.on_attach
return { ---@type vim.lsp.ClientConfig
  cmd = function(dispatchers, config)
    local cmd = 'vscode-eslint-language-server'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  workspace_required = true,
  on_attach = function(client, bufnr)
    if not base_on_attach then
      return
    end

    base_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'LspEslintFixAll',
    })
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'astro',
    'htmlangular',
  },
  settings = {
    codeAction = {
      disableRuleComment = { enable = true, location = 'separateLine' },
      showDocumentation = { enable = true },
    },
    codeActionOnSave = { enable = false, mode = 'all' },
    experimental = { useFlatConfig = false },
    format = true,
    nodePath = '',
    onIgnoredFiles = 'off',
    problems = { shortenToSingleLine = false },
    quiet = false,
    rulesCustomizations = {},
    run = 'onType',
    useESLintClass = false,
    validate = 'on',
    workingDirectory = { mode = 'auto' },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
