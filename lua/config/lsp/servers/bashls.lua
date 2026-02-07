return { ---@type vim.lsp.ClientConfig
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' },
  root_markers = { '.git' },
  settings = {
    bashIde = {
      backgroundAnalysisMaxFiles = 500,
      enableSourceErrorDiagnostics = true,
      globPattern = '**/*@(.sh|.inc|.bash|.command)',
      includeAllWorkspaceSymbols = true,
      logLevel = 'warning',
      shellcheckPath = 'shellcheck',
      shfmt = {
        binaryNextLine = true,
        caseIndent = true,
        funcNextLine = false,
        ignoreEditorconfig = false,
        keepPadding = true,
        languageDialect = 'auto',
        path = 'shfmt',
        simplifyCode = false,
        spaceRedirects = true,
      },
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
