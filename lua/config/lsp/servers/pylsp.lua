return { ---@type vim.lsp.ClientConfig
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  settings = {
    pylsp = {
      configurationSources = { 'flake8' }, ---@type { [1]: 'pycodestyle'|'flake8' }
      plugins = {
        autopep8 = { enabled = true },
        flake8 = {
          enabled = true,
          executable = 'flake8',
          hangClosing = false,
          indentSize = 4,
          maxComplexity = 15,
          maxLineLength = 100,
          ignore = { 'D400', 'D401', 'F401' },
        },
        pycodestyle = {
          enabled = false,
          ignore = { 'D400', 'D401', 'F401' },
          maxLineLength = 100,
          indentSize = 4,
          hangClosing = false,
        },
        pydocstyle = {
          enabled = true,
          convention = 'numpy',
          addIgnore = { 'D400', 'D401' },
          ignore = { 'D400', 'D401' },
        },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        rope_autoimport = { completions = { enabled = false } },
        rope_completion = { enabled = false },
        yapf = { enabled = false },
      },
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
