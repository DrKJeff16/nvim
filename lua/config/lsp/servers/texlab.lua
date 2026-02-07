return { ---@type vim.lsp.ClientConfig
  cmd = { 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = {
    '.git',
    '.latexmkrc',
    'latexmkrc',
    '.texlabroot',
    'texlabroot',
    'Tectonic.toml',
  },
  settings = {
    texlab = {
      bibtexFormatter = 'texlab',
      build = {
        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
        executable = 'latexmk',
        forwardSearchAfter = false,
        onSave = false,
      },
      chktex = { onEdit = false, onOpenAndSave = false },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = { args = {} },
      latexFormatter = 'latexindent',
      latexindent = { modifyLineBreaks = false },
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
