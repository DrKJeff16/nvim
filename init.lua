local INFO = vim.log.levels.INFO
local Opts = require('user_api.opts')
local is_distro = require('user_api.distro').is_distro

function _G.notify_inspect(...)
  ---@type integer, integer, string
  local nargs, i, txt = select('#', ...), 1, ''
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

require('user_api.config.keymaps').set_leader('<Space>')

Opts.setup({
  -- clipboard = 'unnamedplus', -- Uncomment to use system clipboard
  autoindent = true,
  autoread = true,
  background = 'dark',
  backspace = 'indent,eol,start',
  backup = false,
  belloff = 'all',
  cmdwinheight = is_distro('termux') and 15 or 25,
  colorcolumn = '101',
  completeopt = 'menuone,noselect,preview',
  confirm = true,
  copyindent = true,
  encoding = 'utf-8',
  equalalways = true,
  errorbells = false,
  expandtab = true,
  fileformat = 'unix',
  fileignorecase = not require('user_api.check').is_windows(),
  foldenable = false,
  foldmethod = 'manual',
  formatoptions = 'bjlnopqw',
  helplang = 'en',
  hidden = true,
  hlsearch = true,
  ignorecase = false,
  inccommand = 'nosplit',
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
  smartindent = true,
  smarttab = true,
  softtabstop = 4,
  spell = false,
  splitbelow = true,
  splitkeep = 'screen',
  splitright = true,
  switchbuf = 'usetab',
  tabstop = 4,
  textwidth = 100,
  title = true,
  wrap = is_distro('termux'),
}, false, true)

---Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not.
require('user_api').disable_netrw()

require('config.lazy').setup({
  Comment = true,
  alpha = false,
  autopairs = true,
  blink_cmp = true,
  blink_indent = true,
  blink_pairs = false,
  bmessages = false,
  buffer_sticks = false,
  bufferline = true,
  cheaty = true,
  checkmate = false,
  co_author = false,
  code_runner = false,
  codeowners = true,
  diffview = false,
  dooku = false,
  doxygen_init = false,
  doxygen_previewer = true,
  echo = false,
  focus = true,
  fzf_lua = true,
  fzf_nerdfont = false,
  gh_co = false,
  git_gitsigns = true,
  git_lazygit = false,
  git_rehunk = false,
  git_utils = false,
  goto_preview = false,
  helpview = true,
  hlargs = false,
  hoversplit = false,
  ibl = false,
  image = false,
  lastplace = true,
  lazydev = true,
  local_session = false,
  log_highlight = false,
  lsp_better_diagnostic = false,
  lsp_clangd = true,
  lsp_toggle = false,
  lspkind = true,
  lualine = true,
  luaref = true,
  markdoc = false,
  markdown_outline = false,
  markdown_render = true,
  mason = false,
  mini_animate = false,
  mini_basics = true,
  mini_bufremove = true,
  mini_cmdline = false,
  mini_cursorword = false,
  mini_diff = false,
  mini_extra = true,
  mini_icons = true,
  mini_mini = true,
  mini_move = true,
  mini_pairs = false,
  mini_splitjoin = true,
  mini_starter = false,
  mini_test = false,
  mini_trailspace = true,
  music_player = true,
  neo_tree = true,
  noice = true,
  notify = true,
  nvim_test = false,
  outline = true,
  paredit = true,
  persistence = true,
  picker = true,
  pipenv = true,
  project = true,
  python_import = true,
  rainbow_delimiters = false,
  refer = true,
  referencer = false,
  replua = false,
  scope = false,
  screenkey = true,
  scrollbar = false,
  smart_backspace = false,
  smart_paste = true,
  smoothcursor = true,
  snacks = true,
  startuptime = true,
  todo_comments = true,
  toggleterm = true,
  toml = true,
  triforce = true,
  ts_autotag = true,
  ts_commentstring = true,
  ts_context = true,
  ts_init = true,
  ts_vimdoc = true,
  twilight = false,
  undotree = false,
  wezterm_config = true,
  web_devicons = true,
  which_colorscheme = true,
  which_key = true,
  zen_mode = false,
})

local desc = require('user_api.maps').desc
require('user_api.config.keymaps').set({
  n = { ['<C-/>'] = { ':norm gcc<CR><Up>', desc('Toggle Comment') } },
  v = { ['<C-/>'] = { ":'<,'>normal gcc<CR><Up>", desc('Toggle Comment') } },
}, nil, true)

-- Initialize the User API
require('user_api').setup()

Opts.setup_cmds()
Opts.setup_maps()

require('config.autocmds').setup()

require('config.colorschemes')('tokyonight')
-- require('config.colorschemes')('catppuccin')
-- require('config.colorschemes')('everblush')
-- require('config.colorschemes')('calvera')
-- require('config.colorschemes')('lavender')
-- require('config.colorschemes')('flow')
-- require('config.colorschemes')('thorn')
-- require('config.colorschemes')('nightfox')
-- require('config.colorschemes')('conifer')
-- require('config.colorschemes')('tokyodark')
-- require('config.colorschemes')('spaceduck')

if vim.fn.has('nvim-0.11') == 1 then
  vim.cmd.packadd('nohlsearch')
end

if vim.fn.has('nvim-0.12') == 1 then
  vim.cmd.packadd('nvim.undotree')
end

require('config.lsp').setup()
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
