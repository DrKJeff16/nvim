---@module 'lazy'

local ensure_langs = {
  'bash',
  'c',
  'comment',
  'commonlisp',
  'cpp',
  'css',
  'csv',
  'desktop',
  'diff',
  'editorconfig',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitignore',
  'html',
  'hyprlang',
  'ini',
  'jsdoc',
  'json',
  'json5',
  'jsonc',
  'kconfig',
  'kitty',
  'latex',
  'lua',
  'luadoc',
  'luap',
  'make',
  'markdown',
  'markdown_inline',
  'passwd',
  'printf',
  'python',
  'query',
  'readline',
  'regex',
  'requirements',
  'rust',
  'scss',
  'ssh_config',
  'sway',
  'tmux',
  'todotxt',
  'toml',
  'udev',
  'vim',
  'vimdoc',
  'xcompose',
  'xresources',
  'yaml',
  'zathurarc',
  'zsh',
}

if not require('user_api.distro.termux').validate() then
  table.insert(ensure_langs, 'gitcommit')
end

return { ---@type LazySpec
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  version = false,
  config = function()
    require('nvim-treesitter').setup({ install_dir = vim.fn.stdpath('data') .. '/site' })
    require('nvim-treesitter').install(ensure_langs)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        'bash',
        'c',
        'cpp',
        'css',
        'desktop',
        'diff',
        'dosini',
        'editorconfig',
        'gitattributes',
        'gitcommit',
        'gitconfig',
        'gitignore',
        'gitrebase',
        'gpg',
        'html',
        'hyprlang',
        'json',
        'json5',
        'jsonc',
        'kitty',
        'lua',
        'markdown',
        'meson',
        'ninja',
        'passwd',
        'python',
        'query',
        'readline',
        'regex',
        'requirements',
        'robots',
        'rust',
        'scss',
        'sh',
        'sshconfig',
        'tex',
        'tmux',
        'toml',
        'udevconf',
        'udevrules',
        'vim',
        'yaml',
        'zathurarc',
        'zsh',
      },
      callback = function(ev)
        if not vim.api.nvim_buf_is_loaded(ev.buf) then
          return
        end
        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
        if not (lang and vim.treesitter.language.add(lang)) then
          return
        end
        vim.treesitter.start(ev.buf)
      end,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
