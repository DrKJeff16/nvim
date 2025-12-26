return { ---@type vim.lsp.ClientConfig
  cmd = { 'css-variables-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  settings = {
    cssVariables = {
      blacklistFolders = {
        '**/.cache',
        '**/.DS_Store',
        '**/.git',
        '**/.hg',
        '**/.next',
        '**/.svn',
        '**/bower_components',
        '**/CVS',
        '**/dist',
        '**/node_modules',
        '**/tests',
        '**/tmp',
      },
      lookupFiles = { '**/*.less', '**/*.scss', '**/*.sass', '**/*.css' },
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
