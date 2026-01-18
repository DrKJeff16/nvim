local INFO = vim.log.levels.INFO
local Opts = require('user_api.opts')
local Keymaps = require('user_api.config.keymaps')

---[SOURCE](https://stackoverflow.com/questions/7183998/in-lua-what-is-the-right-way-to-handle-varargs-which-contains-nil).
---@param ... any
function _G.notify_inspect(...)
  local nargs = select('#', ...) ---@type integer
  local txt = ''
  local i = 1
  while i <= nargs do
    local selection = select(i, ...)
    if not vim.list_contains({ 'string', 'number', 'boolean', 'nil' }, type(selection)) then
      selection = vim.inspect(selection)
    end

    txt = ('%s' .. (i == 1 and '' or '\n') .. '%s'):format(txt, selection)
    i = i + 1
  end
  vim.notify(txt, INFO)
end

vim.g.loaded_perl_provider = 0

Keymaps.set_leader('<Space>')

Opts.setup({
  autoread = true,
  background = 'dark',
  backspace = 'indent,eol,start',
  backup = false,
  -- clipboard = 'unnamedplus', -- Uncomment to use system clipboard
  cmdwinheight = require('user_api.distro.termux').validate() and 15 or 25,
  colorcolumn = '101',
  confirm = true,
  copyindent = true,
  equalalways = true,
  errorbells = false,
  expandtab = true,
  fileformat = 'unix',
  fileignorecase = not require('user_api.check').is_windows(),
  foldmethod = 'manual',
  formatoptions = 'bjlnopqw',
  helplang = 'en',
  hidden = true,
  hlsearch = true,
  inccommand = 'nosplit',
  ignorecase = false,
  incsearch = true,
  list = true,
  matchpairs = '(:),[:],{:},<:>',
  matchtime = 30,
  menuitems = 50,
  mouse = '',
  number = true,
  preserveindent = true,
  relativenumber = false,
  rightleft = false,
  ruler = true,
  scrolloff = 2,
  secure = false,
  sessionoptions = 'buffers,tabpages,globals',
  shiftwidth = 4,
  showmatch = true,
  showmode = false,
  showtabline = 2,
  signcolumn = 'yes',
  softtabstop = 4,
  spell = false,
  splitbelow = true,
  splitkeep = 'screen',
  splitright = true,
  switchbuf = 'usetab',
  tabstop = 4,
  textwidth = 100,
  title = true,
  wrap = require('user_api.distro.termux').validate(),
})

Opts.set_cursor_blink()

---Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local L = require('config.lazy')
L.setup({
  autopairs = true,
  blink_indent = true,
  blink_pairs = false,
  bmessages = false,
  cheaty = false,
  ibl = false,
  luaref = false,
  mason = false,
  rainbow_delimiters = false,
})

local desc = require('user_api.maps').desc
Keymaps({
  n = {
    ['<leader>vM'] = { vim.cmd.messages, desc('Run `:messages`') },
    ['<leader>vN'] = { vim.cmd.Notifications, desc('Run `:Notifications`') },
    ['<C-/>'] = { '<CMD>norm gcc<CR><Up>', desc('Toggle Comment') },
  },
  v = { ['<C-/>'] = { [[:'<,'>normal gcc<CR>]], desc('Toggle Comment') } },
}, nil, true)

-- Initialize the User API
require('user_api').setup()

L.colorschemes('tokyonight')
-- L.colorschemes('catppuccin')
-- L.colorschemes('everblush')
-- L.colorschemes('calvera')
-- L.colorschemes('lavender')
-- L.colorschemes('flow')
-- L.colorschemes('thorn')
-- L.colorschemes('nightfox')
-- L.colorschemes('conifer')
-- L.colorschemes('tokyodark')
-- L.colorschemes('spaceduck')

vim.cmd.packadd('nohlsearch')

if require('user_api.check.exists').vim_has('nvim-0.12') then
  vim.cmd.packadd('nvim.undotree')
end

L.lsp().setup()
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
