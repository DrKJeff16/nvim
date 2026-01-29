---@module 'lazy'
local ensure_langs = { ---@type string[]
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
  'kconfig',
  'kitty',
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
local patterns = { ---@type string[]
  'bash',
  'c',
  'cpp',
  'css',
  'desktop',
  'diff',
  'dosini',
  'editorconfig',
  'gitattributes',
  'gitconfig',
  'gitignore',
  'gitrebase',
  'gpg',
  'html',
  'hyprlang',
  'json',
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
  'rust',
  'scss',
  'sh',
  'sshconfig',
  'tmux',
  'toml',
  'udevconf',
  'udevrules',
  'vim',
  'yaml',
  'zathurarc',
  'zsh',
}

if not require('user_api.distro.termux').validate() then
  table.insert(ensure_langs, 'gitcommit')
  table.insert(ensure_langs, 'latex')

  table.insert(patterns, 'gitcommit')
  table.insert(patterns, 'tex')
end

return { ---@type LazySpec
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  version = false,
  config = function()
    require('nvim-treesitter').setup({
      install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site'),
    })
    require('nvim-treesitter').install(ensure_langs)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = patterns,
      callback = function(ev)
        if not vim.api.nvim_buf_is_loaded(ev.buf) then
          return
        end
        local lang = vim.treesitter.language.get_lang(
          vim.api.nvim_get_option_value('filetype', { buf = ev.buf })
        )
        if not (lang and vim.treesitter.language.add(lang)) then
          return
        end
        vim.treesitter.start(ev.buf)
      end,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
