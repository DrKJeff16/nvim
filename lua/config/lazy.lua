---@module 'config._meta'

local LAZY_DATA = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
local LAZY_STATE = vim.fs.joinpath(vim.fn.stdpath('state'), 'lazy')
local LAZYPATH = vim.fs.joinpath(LAZY_DATA, 'lazy.nvim')
local User = require('user_api')

---@param mod string
---@param prefix string
---@return LazySpecImport import
---@overload fun(mod: string): import: LazySpecImport
local function make_import(mod, prefix)
  User.check.validate({
    mod = { mod, { 'string' } },
    prefix = { prefix, { 'string', 'nil' }, true },
  })
  prefix = prefix or 'plugin'

  return {
    import = ('%s%s%s'):format(
      prefix ~= '' and prefix or 'plugin',
      vim.list_contains({ prefix:sub(-1), mod:sub(1) }, '.') and '' or '.',
      mod
    ),
  }
end

---@param cmd 'edit'|'tabnew'|'split'|'vsplit'
---@return function command
---@overload fun(): command: function
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
  User.config.keymaps.set({
    n = {
      ['<leader>L'] = { group = '+Lazy' },
      ['<leader>Le'] = { group = '+Edit Lazy File' },
      ['<leader>Lp'] = { group = '+Prompts' },
      ['<leader>L<CR>'] = { ':Lazy ', User.maps.desc('Prompt for `Lazy` Operation', { silent = false }) },
      ['<leader>LC'] = { lazy.clean, User.maps.desc('Clean Lazy Plugins') },
      ['<leader>LL'] = { lazy.log, User.maps.desc('Show Lazy Log') },
      ['<leader>LP'] = { lazy.profile, User.maps.desc('Show Lazy Profile') },
      ['<leader>Lc'] = { lazy.check, User.maps.desc('Check Lazy Plugins') },
      ['<leader>Ld'] = { lazy.debug, User.maps.desc('Debug Lazy Plugins') },
      ['<leader>Lee'] = { key_variant('edit'), User.maps.desc('Open `Lazy` File') },
      ['<leader>Les'] = { key_variant('split'), User.maps.desc('Open `Lazy` File Horizontal Window') },
      ['<leader>Let'] = { key_variant('tabnew'), User.maps.desc('Open `Lazy` File Tab') },
      ['<leader>Lev'] = { key_variant('vsplit'), User.maps.desc('Open `Lazy`File Vertical Window') },
      ['<leader>Lh'] = { lazy.health, User.maps.desc('Run Lazy checkhealth') },
      ['<leader>Li'] = { lazy.install, User.maps.desc('Install Lazy Plugins') },
      ['<leader>Ll'] = { lazy.show, User.maps.desc('Show Lazy Home') },
      ['<leader>Lpb'] = { ':Lazy build ', User.maps.desc('Prompt To Build', { silent = false }) },
      ['<leader>Lpl'] = { ':Lazy load ', User.maps.desc('Prompt To Load', { silent = false }) },
      ['<leader>Lpr'] = { ':Lazy reload ', User.maps.desc('Prompt To Reload', { silent = false }) },
      ['<leader>Ls'] = { lazy.sync, User.maps.desc('Sync Lazy Plugins') },
      ['<leader>Lu'] = { lazy.update, User.maps.desc('Update Lazy Plugins') },
      ['<leader>Lx'] = { lazy.clear, User.maps.desc('Clear Lazy Plugins') },
      ['<leader>vhL'] = { lazy.health, User.maps.desc('Run Lazy checkhealth') },
    },
  })
end

---@class Config.Lazy
local M = {}

---@return LazyPlugins specs
function M.get_default_specs()
  return { ---@type LazyPlugins
    Comment = make_import('Comment'),
    alpha = make_import('alpha'),
    autopairs = make_import('autopairs'),
    barbar = make_import('barbar'),
    battery = make_import('battery'),
    blink = make_import('blink.init'),
    blink_cmp = make_import('blink.cmp'),
    blink_indent = make_import('blink.indent'),
    blink_lib = make_import('blink.lib'),
    blink_pairs = make_import('blink.pairs'),
    boolean_toggle = make_import('boolean-toggle'),
    bmessages = make_import('bmessages'),
    bookmarks = make_import('bookmarks'),
    buffer_sticks = make_import('buffer-sticks'),
    bufferline = make_import('bufferline'),
    ccc = make_import('ccc'),
    cheaty = make_import('cheaty'),
    checkmate = make_import('checkmate'),
    classlayout = make_import('classlayout'),
    code_runner = make_import('code-runner'),
    codedocs = make_import('codedocs'),
    syntax_codeowners = make_import('syntax.codeowners'),
    syntax_gentoo = make_import('syntax.gentoo'),
    syntax_tridactyl = make_import('syntax.tridactyl'),
    color_skimer = make_import('color-skimer'),
    colorschemes = make_import('colorschemes'),
    colorizer = make_import('colorizer'),
    conform = make_import('conform'),
    copy_python_path = make_import('copy-python-path'),
    csvview = make_import('csvview'),
    data = make_import('data'),
    diffview = make_import('diffview'),
    dooku = make_import('dooku'),
    doxygen = make_import('doxygen.init'),
    doxygen_previewer = make_import('doxygen.previewer'),
    drop = make_import('drop'),
    dropbar = make_import('dropbar'),
    echo = make_import('echo'),
    firenvim = make_import('firenvim'),
    flash = make_import('flash'),
    fff = make_import('fff'),
    focus = make_import('focus'),
    fzf_lua = make_import('fzf-lua'),
    fzf_nerdfont = make_import('fzf-nerdfont'),
    git_co_author = make_import('git.co-author'),
    git_gh_co = make_import('git.gh-co'),
    git_ghactions = make_import('git.gh-actions'),
    git_ghrelease = make_import('git.ghrelease'),
    git_gitsigns = make_import('git.gitsigns'),
    git_guh = make_import('git.guh'),
    git_hunk = make_import('git.hunk'),
    git_inlinediff = make_import('git.inlinediff'),
    git_lazygit = make_import('git.lazygit'),
    git_neogit = make_import('git.neogit'),
    git_rehunk = make_import('git.rehunk'),
    git_utils = make_import('git.utils'),
    goto_preview = make_import('goto-preview'),
    helpview = make_import('helpview'),
    hlargs = make_import('hlargs'),
    hoversplit = make_import('hoversplit'),
    ibl = make_import('ibl'),
    image = make_import('image'),
    lastplace = make_import('lastplace'),
    local_session = make_import('local-session'),
    log_highlight = make_import('log-highlight'),
    lsp = make_import('lsp.init'),
    lsp_better_diagnostic = make_import('lsp.better-diagnostic'),
    lsp_clangd = make_import('lsp.clangd'),
    lsp_custom_diagnostic_highlight = make_import('lsp.custom-diagnostic-highlight'),
    lsp_fidget = make_import('lsp.fidget'),
    lsp_file_operations = make_import('lsp.file-operations'),
    lsp_lazydev = make_import('lsp.lazydev'),
    lsp_lspsaga = make_import('lsp.lspsaga'),
    lsp_schemastore = make_import('lsp.schemastore'),
    lsp_toggle = make_import('lsp.toggle'),
    lspkind = make_import('lspkind'),
    lualine = make_import('lualine'),
    luaref = make_import('luaref'),
    markdoc = make_import('markdoc'),
    markdown = make_import('markdown.init'),
    markdown_follow_md_links = make_import('markdown.follow-md-links'),
    markdown_mdview = make_import('markdown.mdview'),
    markdown_outline = make_import('markdown.outline'),
    markdown_pipetable = make_import('markdown.pipetable'),
    markdown_render = make_import('markdown.render'),
    markdown_toc = make_import('markdown.toc'),
    mason = make_import('mason'),
    match = make_import('match'),
    migrate = make_import('migrate'),
    mini_animate = make_import('mini.animate'),
    mini_basics = make_import('mini.basics'),
    mini_base16 = make_import('mini.base16'),
    mini_bufremove = make_import('mini.bufremove'),
    mini_cmdline = make_import('mini.cmdline'),
    mini_cursorword = make_import('mini.cursorword'),
    mini_diff = make_import('mini.diff'),
    mini_extra = make_import('mini.extra'),
    mini_icons = make_import('mini.icons'),
    mini_input = make_import('mini.input'),
    mini_mini = make_import('mini.mini'),
    mini_move = make_import('mini.move'),
    mini_pairs = make_import('mini.pairs'),
    mini_pick = make_import('mini.pick'),
    mini_splitjoin = make_import('mini.splitjoin'),
    mini_starter = make_import('mini.starter'),
    mini_test = make_import('mini.test'),
    mini_trailspace = make_import('mini.trailspace'),
    music_player = make_import('music-player'),
    neo_tree = make_import('neo-tree'),
    neorg = make_import('neorg'),
    noice = make_import('noice'),
    notify = make_import('notify'),
    nvim_test = make_import('nvim-test'),
    nvim_tree = make_import('nvim-tree'),
    oil = make_import('oil.init'),
    oil_git = make_import('oil.git'),
    orgmode = make_import('orgmode'),
    outline = make_import('outline'),
    paredit = make_import('paredit'),
    persistence = make_import('persistence'),
    picker = make_import('picker'),
    pipenv = make_import('pipenv'),
    pomo = make_import('pomo'),
    pomodoro = make_import('pomodoro'),
    possession = make_import('possession'),
    precognition = make_import('precognition'),
    project = make_import('project'),
    python_import = make_import('python.import'),
    rainbow_delimiters = make_import('rainbow-delimiters'),
    real_icons = make_import('real-icons'),
    record_key = make_import('record-key'),
    refactoring = make_import('refactoring'),
    refer = make_import('refer'),
    referencer = make_import('referencer'),
    replua = make_import('replua'),
    required = make_import('required'),
    scope = make_import('scope'),
    screenkey = make_import('screenkey'),
    scrollbar = make_import('scrollbar'),
    shebang = make_import('shebang'),
    smart_backspace = make_import('smart-backspace'),
    smart_paste = make_import('smart-paste'),
    smoothcursor = make_import('smoothcursor'),
    snacks = make_import('snacks'),
    spinner = make_import('spinner'),
    startuptime = make_import('startuptime'),
    styler = make_import('styler'),
    stylua = make_import('stylua'),
    telescope = make_import('telescope.init'),
    tobira = make_import('tobira'),
    todo = make_import('todo'),
    todo_comments = make_import('todo-comments'),
    tmux = make_import('tmux'),
    toggleterm = make_import('toggleterm'),
    toml = make_import('toml'),
    triforce = make_import('triforce'),
    trouble = make_import('trouble'),
    ts_autotag = make_import('ts.autotag'),
    ts_commentstring = make_import('ts.commentstring'),
    ts_context = make_import('ts.context'),
    ts_enable = make_import('ts.enable'),
    ts_endwise = make_import('ts.endwise'),
    ts = make_import('ts.init'),
    ts_vimdoc = make_import('ts.vimdoc'),
    twilight = make_import('twilight'),
    web_devicons = make_import('web-devicons'),
    wezterm_config = make_import('wezterm-config'),
    which_colorscheme = make_import('which-colorscheme'),
    which_key = make_import('which-key'),
    window_picker = make_import('window-picker'),
    yanky = make_import('yanky'),
    zen_mode = make_import('zen-mode'),
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
    git_neogit = true,
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
    lsp_file_operations = true,
    lsp_lazydev = true,
    lsp_lspsaga = true,
    lsp_schemastore = true,
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
    real_icons = false,
    record_key = true,
    refactoring = false,
    refer = false,
    referencer = false,
    replua = false,
    required = true,
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
---@param toggles table<string, LazySpec|string|LazyPluginSpec|boolean>|LazyToggle
---@overload fun()
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
