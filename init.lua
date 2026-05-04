---@module 'lazy'

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
  formatoptions = 'jlnopw/',
  helplang = 'en',
  hidden = true,
  hlsearch = true,
  ignorecase = false,
  inccommand = 'nosplit',
  incsearch = true,
  list = true,
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
  title = true,
  wrap = is_distro('termux'),
}, false, true)

---Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not.
require('user_api').disable_netrw()

require('config.lazy').setup({
  Comment = true,
  alpha = false,
  autopairs = true,
  barbar = true,
  blink = true,
  blink_cmp = true,
  blink_indent = true,
  blink_pairs = false,
  bmessages = false,
  bookmarks = false,
  boolean_toggle = true,
  buffer_sticks = false,
  bufferline = false,
  cheaty = false,
  checkmate = false,
  classlayout = false,
  co_author = true,
  code_runner = false,
  codeowners = true,
  color_skimer = false,
  colorizer = true,
  conform = true,
  diffview = false,
  dooku = false,
  doxygen_init = false,
  doxygen_previewer = true,
  echo = false,
  focus = true,
  fzf_lua = true,
  fzf_nerdfont = false,
  gh_co = true,
  git_gitsigns = true,
  git_inlinediff = false,
  git_lazygit = false,
  git_rehunk = false,
  git_utils = false,
  goto_preview = false,
  helpview = false,
  hlargs = false,
  hoversplit = false,
  ibl = false,
  image = false,
  lastplace = true,
  lazydev = true,
  local_session = false,
  log_highlight = false,
  lsp = true,
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
  mini_base16 = false,
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
  mini_pick = false,
  mini_splitjoin = true,
  mini_starter = false,
  mini_test = false,
  mini_trailspace = true,
  music_player = true,
  neo_tree = true,
  neorg = false,
  noice = true,
  notify = true,
  nvim_test = false,
  oil = true,
  oil_git = true,
  orgmode = false,
  outline = true,
  paredit = true,
  persistence = true,
  picker = true,
  pipenv = true,
  pomo = false,
  possession = false,
  precognition = false,
  project = true,
  python_import = true,
  rainbow_delimiters = false,
  record_key = false,
  refactoring = false,
  refer = false,
  referencer = false,
  replua = false,
  scope = false,
  screenkey = true,
  scrollbar = false,
  shebang = true,
  smart_backspace = false,
  smart_paste = true,
  smoothcursor = true,
  snacks = true,
  startuptime = true,
  stylua = false,
  telescope = true,
  todo_comments = true,
  toggleterm = true,
  toml = true,
  triforce = true,
  ts_autotag = false,
  ts_commentstring = true,
  ts_context = true,
  ts_init = true,
  ts_vimdoc = true,
  twilight = false,
  undotree = false,
  web_devicons = true,
  wezterm_config = true,
  which_colorscheme = true,
  which_key = true,
  window_picker = false,
  wrapped = false,
  yanky = false,
  zen_mode = false,
})

local desc = require('user_api.maps').new_desc
require('user_api.config.keymaps').set({
  n = { ['<C-/>'] = { ':norm gcc<CR><Up>', desc('Toggle Comment') } },
  v = { ['<C-/>'] = { ":'<,'>normal gcc<CR><Up>", desc('Toggle Comment') } },
}, nil, true)

-- Initialize the User API
require('user_api').setup()

Opts.setup_cmds()
Opts.setup_maps()

require('config.autocmds').setup()

vim.cmd([[
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
]])

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
