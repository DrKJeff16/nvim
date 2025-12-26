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
        jedi_completion = {
          enabled = true,
          eager = true,
          fuzzy = true,
          resolve_at_most = 50,
        },
        jedi_definition = {
          enabled = true,
          follow_imports = true,
          follow_builtin_imports = true,
          follow_builtin_definitions = true,
        },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true, all_scopes = true, include_import_symbols = true },
        mccabe = { enabled = true, threshold = 15 },
        preload = { enabled = true, modules = { 'sys', 'typing', 'os', 'argparse' } },
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
        rope_autoimport = { completions = { enabled = true } },
        rope_completion = { enabled = true, eager = true },
        yapf = { enabled = false },
      },
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
