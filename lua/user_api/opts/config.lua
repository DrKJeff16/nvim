---@class User.Opts.Spec: vim.wo,vim.bo
local M = {
  autoindent = true,
  autoread = true,
  backspace = 'indent,eol,start',
  backup = false,
  belloff = 'all',
  copyindent = false,
  encoding = 'utf-8',
  errorbells = false,
  expandtab = true,
  foldmethod = 'manual',
  formatoptions = 'bjlnopqw',
  helplang = 'en',
  hidden = true,
  hlsearch = true,
  incsearch = true,
  laststatus = 2,
  makeprg = 'make',
  matchpairs = '(:),[:],{:},<:>',
  mouse = '',
  number = true,
  numberwidth = 4,
  preserveindent = false,
  relativenumber = false,
  ruler = true,
  shiftwidth = 4,
  showcmd = true,
  showmatch = true,
  showmode = false,
  showtabline = 2,
  signcolumn = 'yes',
  smartcase = true,
  smartindent = true,
  smarttab = true,
  softtabstop = 4,
  spell = false,
  splitbelow = true,
  splitright = true,
  tabstop = 4,
  termguicolors = true,
  updatecount = 100,
  updatetime = 1000,
  visualbell = false,
  wildmenu = true,
}

if vim.fn.has('win32') == 1 then
  local executable = require('user_api.check.exists').executable
  if executable('mingw32-make') then
    M.makeprg = 'mingw32-make'
  end

  if executable({ 'bash', 'sh' }) then
    M.shell = executable('bash') and 'bash' or 'sh'
    M.shellcmdflag = '-c'
  elseif executable('pwsh') then
    M.shell = 'pwsh'
  end

  M.fileignorecase = true
  M.shellslash = true
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
