---@module 'config._meta'

local LAZY_DATA = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
local LAZY_STATE = vim.fs.joinpath(vim.fn.stdpath('state'), 'lazy')
local LAZYPATH = vim.fs.joinpath(LAZY_DATA, 'lazy.nvim')
local User = require('user_api')

---@param mod string
---@return LazySpecImport import
local function make_import(mod)
  return { import = mod }
end

---@param cmd? 'edit'|'tabnew'|'split'|'vsplit'
---@return function command
local function key_variant(cmd)
  User.check.validate({ cmd = { cmd, { 'string', 'nil' }, true } })
  cmd = (cmd and vim.list_contains({ 'edit', 'tabnew', 'split', 'vsplit' }, cmd)) and cmd or 'edit'

  return function()
    vim.cmd[cmd]({ args = { vim.fs.joinpath(vim.fn.stdpath('config'), 'lua/config/lazy.lua') } })
  end
end

---@return boolean has_luarocks
local function luarocks_check()
  return User.check.executable('luarocks') and User.check.env_vars({ 'LUA_PATH', 'LUA_CPATH' })
end

---@param lazy Lazy
local function setup_keys(lazy)
  local desc = require('user_api').maps.desc
  require('user_api').config.keymaps.set({
    n = {
      ['<leader>L'] = { group = '+Lazy' },
      ['<leader>Le'] = { group = '+Edit Lazy File' },
      ['<leader>Lp'] = { group = '+Prompts' },
      ['<leader>L<CR>'] = { ':Lazy ', desc('Prompt for `Lazy` Operation', { silent = false }) },
      ['<leader>LC'] = { lazy.clean, desc('Clean Lazy Plugins') },
      ['<leader>LL'] = { lazy.log, desc('Show Lazy Log') },
      ['<leader>LP'] = { lazy.profile, desc('Show Lazy Profile') },
      ['<leader>Lc'] = { lazy.check, desc('Check Lazy Plugins') },
      ['<leader>Ld'] = { lazy.debug, desc('Debug Lazy Plugins') },
      ['<leader>Lee'] = { key_variant('edit'), desc('Open `Lazy` File') },
      ['<leader>Les'] = { key_variant('split'), desc('Open `Lazy` File Horizontal Window') },
      ['<leader>Let'] = { key_variant('tabnew'), desc('Open `Lazy` File Tab') },
      ['<leader>Lev'] = { key_variant('vsplit'), desc('Open `Lazy`File Vertical Window') },
      ['<leader>Lh'] = { lazy.health, desc('Run Lazy checkhealth') },
      ['<leader>Li'] = { lazy.install, desc('Install Lazy Plugins') },
      ['<leader>Ll'] = { lazy.show, desc('Show Lazy Home') },
      ['<leader>Lpb'] = { ':Lazy build ', desc('Prompt To Build', { silent = false }) },
      ['<leader>Lpl'] = { ':Lazy load ', desc('Prompt To Load', { silent = false }) },
      ['<leader>Lpr'] = { ':Lazy reload ', desc('Prompt To Reload', { silent = false }) },
      ['<leader>Ls'] = { lazy.sync, desc('Sync Lazy Plugins') },
      ['<leader>Lu'] = { lazy.update, desc('Update Lazy Plugins') },
      ['<leader>Lx'] = { lazy.clear, desc('Clear Lazy Plugins') },
      ['<leader>vhL'] = { lazy.health, desc('Run Lazy checkhealth') },
    },
  })
end

---@class Config.Lazy
local M = {}

---@return LazyPlugins specs
function M.get_default_specs()
  return { ---@type LazyPlugins
    Comment = make_import('plugin.Comment'),
    alpha = make_import('plugin.alpha'),
    autopairs = make_import('plugin.autopairs'),
    barbar = make_import('plugin.barbar'),
    battery = make_import('plugin.battery'),
    blink = make_import('plugin.blink.init'),
    blink_cmp = make_import('plugin.blink.cmp'),
    blink_indent = make_import('plugin.blink.indent'),
    blink_lib = make_import('plugin.blink.lib'),
    blink_pairs = make_import('plugin.blink.pairs'),
    boolean_toggle = make_import('plugin.boolean-toggle'),
    bmessages = make_import('plugin.bmessages'),
    bookmarks = make_import('plugin.bookmarks'),
    buffer_sticks = make_import('plugin.buffer-sticks'),
    bufferline = make_import('plugin.bufferline'),
    ccc = make_import('plugin.ccc'),
    cheaty = make_import('plugin.cheaty'),
    checkmate = make_import('plugin.checkmate'),
    classlayout = make_import('plugin.classlayout'),
    code_runner = make_import('plugin.code-runner'),
    codedocs = make_import('plugin.codedocs'),
    syntax_codeowners = make_import('plugin.syntax.codeowners'),
    syntax_gentoo = make_import('plugin.syntax.gentoo'),
    syntax_tridactyl = make_import('plugin.syntax.tridactyl'),
    color_skimer = make_import('plugin.color-skimer'),
    colorschemes = make_import('plugin.colorschemes'),
    colorizer = make_import('plugin.colorizer'),
    conform = make_import('plugin.conform'),
    copy_python_path = make_import('plugin.copy-python-path'),
    csvview = make_import('plugin.csvview'),
    data = make_import('plugin.data'),
    diffview = make_import('plugin.diffview'),
    dooku = make_import('plugin.dooku'),
    doxygen = make_import('plugin.doxygen.init'),
    doxygen_previewer = make_import('plugin.doxygen.previewer'),
    drop = make_import('plugin.drop'),
    dropbar = make_import('plugin.dropbar'),
    echo = make_import('plugin.echo'),
    firenvim = make_import('plugin.firenvim'),
    flash = make_import('plugin.flash'),
    fff = make_import('plugin.fff'),
    focus = make_import('plugin.focus'),
    fzf_lua = make_import('plugin.fzf-lua'),
    fzf_nerdfont = make_import('plugin.fzf-nerdfont'),
    git_co_author = make_import('plugin.git.co-author'),
    git_gh_co = make_import('plugin.git.gh-co'),
    git_ghactions = make_import('plugin.git.gh-actions'),
    git_ghrelease = make_import('plugin.git.ghrelease'),
    git_gitsigns = make_import('plugin.git.gitsigns'),
    git_guh = make_import('plugin.git.guh'),
    git_hunk = make_import('plugin.git.hunk'),
    git_inlinediff = make_import('plugin.git.inlinediff'),
    git_lazygit = make_import('plugin.git.lazygit'),
    git_rehunk = make_import('plugin.git.rehunk'),
    git_utils = make_import('plugin.git.utils'),
    goto_preview = make_import('plugin.goto-preview'),
    helpview = make_import('plugin.helpview'),
    hlargs = make_import('plugin.hlargs'),
    hoversplit = make_import('plugin.hoversplit'),
    ibl = make_import('plugin.ibl'),
    image = make_import('plugin.image'),
    lastplace = make_import('plugin.lastplace'),
    local_session = make_import('plugin.local-session'),
    log_highlight = make_import('plugin.log-highlight'),
    lsp = make_import('plugin.lsp.init'),
    lsp_better_diagnostic = make_import('plugin.lsp.better-diagnostic'),
    lsp_clangd = make_import('plugin.lsp.clangd'),
    lsp_custom_diagnostic_highlight = make_import('plugin.lsp.custom-diagnostic-highlight'),
    lsp_fidget = make_import('plugin.lsp.fidget'),
    lsp_lazydev = make_import('plugin.lsp.lazydev'),
    lsp_lspsaga = make_import('plugin.lsp.lspsaga'),
    lsp_toggle = make_import('plugin.lsp.toggle'),
    lspkind = make_import('plugin.lspkind'),
    lualine = make_import('plugin.lualine'),
    luaref = make_import('plugin.luaref'),
    markdoc = make_import('plugin.markdoc'),
    markdown = make_import('plugin.markdown.init'),
    markdown_follow_md_links = make_import('plugin.markdown.follow-md-links'),
    markdown_mdview = make_import('plugin.markdown.mdview'),
    markdown_outline = make_import('plugin.markdown.outline'),
    markdown_pipetable = make_import('plugin.markdown.pipetable'),
    markdown_render = make_import('plugin.markdown.render'),
    markdown_toc = make_import('plugin.markdown.toc'),
    mason = make_import('plugin.mason'),
    match = make_import('plugin.match'),
    migrate = make_import('plugin.migrate'),
    mini_animate = make_import('plugin.mini.animate'),
    mini_basics = make_import('plugin.mini.basics'),
    mini_base16 = make_import('plugin.mini.base16'),
    mini_bufremove = make_import('plugin.mini.bufremove'),
    mini_cmdline = make_import('plugin.mini.cmdline'),
    mini_cursorword = make_import('plugin.mini.cursorword'),
    mini_diff = make_import('plugin.mini.diff'),
    mini_extra = make_import('plugin.mini.extra'),
    mini_icons = make_import('plugin.mini.icons'),
    mini_input = make_import('plugin.mini.input'),
    mini_mini = make_import('plugin.mini.mini'),
    mini_move = make_import('plugin.mini.move'),
    mini_pairs = make_import('plugin.mini.pairs'),
    mini_pick = make_import('plugin.mini.pick'),
    mini_splitjoin = make_import('plugin.mini.splitjoin'),
    mini_starter = make_import('plugin.mini.starter'),
    mini_test = make_import('plugin.mini.test'),
    mini_trailspace = make_import('plugin.mini.trailspace'),
    music_player = make_import('plugin.music-player'),
    neo_tree = make_import('plugin.neo-tree'),
    neorg = make_import('plugin.neorg'),
    noice = make_import('plugin.noice'),
    notify = make_import('plugin.notify'),
    nvim_test = make_import('plugin.nvim-test'),
    nvim_tree = make_import('plugin.nvim-tree'),
    oil = make_import('plugin.oil.init'),
    oil_git = make_import('plugin.oil.git'),
    orgmode = make_import('plugin.orgmode'),
    outline = make_import('plugin.outline'),
    paredit = make_import('plugin.paredit'),
    persistence = make_import('plugin.persistence'),
    picker = make_import('plugin.picker'),
    pipenv = make_import('plugin.pipenv'),
    pomo = make_import('plugin.pomo'),
    pomodoro = make_import('plugin.pomodoro'),
    possession = make_import('plugin.possession'),
    precognition = make_import('plugin.precognition'),
    project = make_import('plugin.project'),
    python_import = make_import('plugin.python.import'),
    rainbow_delimiters = make_import('plugin.rainbow-delimiters'),
    real_icons = make_import('plugin.real-icons'),
    record_key = make_import('plugin.record-key'),
    refactoring = make_import('plugin.refactoring'),
    refer = make_import('plugin.refer'),
    referencer = make_import('plugin.referencer'),
    replua = make_import('plugin.replua'),
    scope = make_import('plugin.scope'),
    screenkey = make_import('plugin.screenkey'),
    scrollbar = make_import('plugin.scrollbar'),
    shebang = make_import('plugin.shebang'),
    smart_backspace = make_import('plugin.smart-backspace'),
    smart_paste = make_import('plugin.smart-paste'),
    smoothcursor = make_import('plugin.smoothcursor'),
    snacks = make_import('plugin.snacks'),
    spinner = make_import('plugin.spinner'),
    startuptime = make_import('plugin.startuptime'),
    styler = make_import('plugin.styler'),
    stylua = make_import('plugin.stylua'),
    telescope = make_import('plugin.telescope.init'),
    tobira = make_import('plugin.tobira'),
    todo = make_import('plugin.todo'),
    todo_comments = make_import('plugin.todo-comments'),
    tmux = make_import('plugin.tmux'),
    toggleterm = make_import('plugin.toggleterm'),
    toml = make_import('plugin.toml'),
    triforce = make_import('plugin.triforce'),
    trouble = make_import('plugin.trouble'),
    ts_autotag = make_import('plugin.ts.autotag'),
    ts_commentstring = make_import('plugin.ts.commentstring'),
    ts_context = make_import('plugin.ts.context'),
    ts_enable = make_import('plugin.ts.enable'),
    ts_endwise = make_import('plugin.ts.endwise'),
    ts = make_import('plugin.ts.init'),
    ts_vimdoc = make_import('plugin.ts.vimdoc'),
    twilight = make_import('plugin.twilight'),
    web_devicons = make_import('plugin.web-devicons'),
    wezterm_config = make_import('plugin.wezterm-config'),
    which_colorscheme = make_import('plugin.which-colorscheme'),
    which_key = make_import('plugin.which-key'),
    window_picker = make_import('plugin.window-picker'),
    yanky = make_import('plugin.yanky'),
    zen_mode = make_import('plugin.zen-mode'),
  }
end

local function bootstrap()
  if vim.g.lazy_bootstrapped == 1 then
    return
  end

  if not (vim.uv or vim.loop).fs_stat(LAZYPATH) then
    local out = vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      LAZYPATH,
    })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { '(config.lazy): Failed to clone lazy.nvim:\n', 'ErrorMsg' },
        { out, 'WarningMsg' },
        { '\nPress any key to exit...' },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  if not vim.o.runtimepath:find(LAZYPATH) then
    vim.o.runtimepath = ('%s,%s'):format(LAZYPATH, vim.o.runtimepath)
  end

  vim.g.lazy_bootstrapped = 1
end

---@return LazyToggles toggles
function M.get_default_toggles()
  return { ---@type LazyToggles
    Comment = true,
    alpha = false,
    autopairs = true,
    barbar = true,
    battery = true,
    blink = true,
    blink_cmp = true,
    blink_indent = true,
    blink_lib = true,
    blink_pairs = true,
    boolean_toggle = true,
    bmessages = false,
    bookmarks = true,
    buffer_sticks = false,
    bufferline = false,
    ccc = true,
    cheaty = false,
    checkmate = false,
    classlayout = true,
    code_runner = false,
    codedocs = false,
    color_skimer = false,
    colorschemes = true,
    colorizer = true,
    conform = true,
    copy_python_path = true,
    csvview = true,
    data = true,
    diffview = false,
    dooku = false,
    doxygen = false,
    doxygen_previewer = true,
    drop = true,
    dropbar = true,
    echo = false,
    firenvim = false,
    flash = true,
    fff = true,
    focus = true,
    fzf_lua = true,
    fzf_nerdfont = false,
    git_co_author = false,
    git_gh_co = false,
    git_gitsigns = true,
    git_ghactions = true,
    git_ghrelease = true,
    git_guh = true,
    git_hunk = true,
    git_inlinediff = true,
    git_lazygit = false,
    git_rehunk = true,
    git_utils = true,
    goto_preview = true,
    helpview = true,
    hlargs = false,
    hoversplit = true,
    ibl = true,
    image = true,
    lastplace = true,
    local_session = false,
    log_highlight = false,
    lsp = true,
    lsp_better_diagnostic = false,
    lsp_clangd = true,
    lsp_custom_diagnostic_highlight = true,
    lsp_fidget = true,
    lsp_lazydev = true,
    lsp_lspsaga = true,
    lsp_toggle = false,
    lspkind = true,
    lualine = true,
    luaref = true,
    markdoc = false,
    markdown = true,
    markdown_follow_md_links = true,
    markdown_mdview = true,
    markdown_outline = false,
    markdown_pipetable = true,
    markdown_render = true,
    markdown_toc = false,
    mason = true,
    match = true,
    migrate = true,
    mini_animate = false,
    mini_basics = true,
    mini_base16 = true,
    mini_bufremove = true,
    mini_cmdline = true,
    mini_cursorword = true,
    mini_diff = false,
    mini_extra = true,
    mini_icons = true,
    mini_input = true,
    mini_mini = true,
    mini_move = true,
    mini_pairs = false,
    mini_pick = true,
    mini_splitjoin = true,
    mini_starter = true,
    mini_test = false,
    mini_trailspace = true,
    music_player = true,
    neo_tree = false,
    neorg = false,
    noice = true,
    notify = false,
    nvim_test = false,
    nvim_tree = true,
    oil = true,
    oil_git = true,
    orgmode = false,
    outline = true,
    paredit = true,
    persistence = true,
    picker = true,
    pipenv = true,
    pomo = false,
    pomodoro = false,
    possession = false,
    precognition = false,
    project = true,
    python_import = true,
    rainbow_delimiters = true,
    real_icons = true,
    record_key = true,
    refactoring = false,
    refer = false,
    referencer = false,
    replua = false,
    scope = true,
    screenkey = true,
    scrollbar = false,
    shebang = true,
    smart_backspace = true,
    smart_paste = true,
    smoothcursor = true,
    snacks = true,
    spinner = true,
    startuptime = true,
    styler = true,
    stylua = true,
    syntax_codeowners = true,
    syntax_gentoo = true,
    syntax_tridactyl = true,
    telescope = false,
    tmux = true,
    tobira = false,
    todo = true,
    todo_comments = true,
    toggleterm = true,
    toml = true,
    triforce = true,
    trouble = true,
    ts_autotag = true,
    ts_commentstring = true,
    ts_context = true,
    ts_enable = false,
    ts_endwise = true,
    ts = true,
    ts_vimdoc = true,
    twilight = false,
    web_devicons = true,
    wezterm_config = false,
    which_colorscheme = true,
    which_key = true,
    window_picker = true,
    yanky = false,
    zen_mode = false,
  }
end

---Sets up `lazy.nvim`. Only runs once!
--- ---
---@param toggles? table<string, LazySpec|string|LazyPluginSpec|boolean>|LazyToggle
function M.setup(toggles)
  require('user_api').check.validate({ toggles = { toggles, { 'table', 'nil' }, true } })
  toggles = vim.tbl_deep_extend('keep', toggles or {}, M.get_default_toggles())

  bootstrap()

  if vim.g.lazy_did_setup then
    return
  end

  local dict = M.get_default_specs()
  local dict_keys = vim.tbl_keys(dict) ---@type string[]
  local specs, err = {}, '' ---@type (string|LazyPluginSpec|LazySpecImport)[], string
  for name, val in pairs(toggles) do
    if type(val) == 'boolean' and vim.list_contains(dict_keys, name) and val then
      table.insert(specs, dict[name])
    elseif type(val) == 'boolean' and not val then
      specs = specs
    elseif type(val) == 'boolean' and not vim.list_contains(dict_keys, name) then
      err = ('%s`%s` is not a valid toggle! Try adding the spec manually.\n'):format(err, name)
    elseif type(val) == 'string' or type(val) == 'table' then
      table.insert(specs, val)
    elseif type(val) ~= 'string' and type(val) ~= 'table' then
      err = ('%sInvalid toggle/spec: `%s`\n'):format(err, vim.inspect(val))
    end
  end

  if err ~= '' then
    vim.schedule(function()
      vim.notify(err, vim.log.levels.WARN)
    end)
  end

  local Lazy = require('lazy')
  Lazy.setup({
    change_detection = { enabled = true, notify = true },
    checker = { check_pinned = false, enabled = true, frequency = 600, notify = true },
    debug = false,
    defaults = { lazy = false, version = false },
    dev = { path = '~/Projects/nvim', patterns = {}, fallback = true },
    headless = { colors = true, log = true, process = true, task = true },
    install = { colorscheme = { 'habamax' }, missing = true },
    performance = {
      reset_packpath = true,
      rtp = { disabled_plugins = { 'netrwPlugin', 'tohtml', 'tutor' }, reset = true },
    },
    pkg = {
      cache = vim.fs.joinpath(LAZY_STATE, 'pkg-cache.lua'),
      enabled = true,
      sources = { 'lazy', 'packspec', luarocks_check() and 'rockspec' or nil },
      versions = true,
    },
    profiling = { loader = true, require = true },
    readme = { enabled = false },
    rocks = { enabled = luarocks_check(), root = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy-rocks') },
    root = LAZY_DATA,
    spec = specs,
    state = vim.fs.joinpath(LAZY_STATE, 'state.json'),
    ui = {
      backdrop = 100,
      border = 'double',
      pills = true,
      title = ('L%sA%sZ%sY'):format((' '):rep(12), (' '):rep(12), (' '):rep(12)),
      title_pos = 'center',
      wrap = true,
    },
  })

  setup_keys(Lazy)
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
