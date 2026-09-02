---@module 'config._meta'

local LAZY_DATA = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
local LAZY_STATE = vim.fs.joinpath(vim.fn.stdpath('state'), 'lazy')
local LAZYPATH = vim.fs.joinpath(LAZY_DATA, 'lazy.nvim')
local README_PATH = vim.fs.joinpath(LAZY_STATE, 'readme')

local function setup_keys()
  local key_variant = require('config.util').key_variant
  local desc = require('user_api').maps.desc
  local Lazy = require('lazy')
  require('user_api').config.keymaps.set({
    n = {
      ['<leader>L'] = { group = '+Lazy' },
      ['<leader>Le'] = { group = '+Edit Lazy File' },
      ['<leader>Lp'] = { group = '+Prompts' },
      ['<leader>L<CR>'] = { ':Lazy ', desc('Prompt for `Lazy` Operation', { silent = false }) },
      ['<leader>LC'] = { Lazy.clean, desc('Clean Lazy Plugins') },
      ['<leader>LL'] = { Lazy.log, desc('Show Lazy Log') },
      ['<leader>LP'] = { Lazy.profile, desc('Show Lazy Profile') },
      ['<leader>Lc'] = { Lazy.check, desc('Check Lazy Plugins') },
      ['<leader>Ld'] = { Lazy.debug, desc('Debug Lazy Plugins') },
      ['<leader>Lee'] = { key_variant('edit'), desc('Open `Lazy` File') },
      ['<leader>Les'] = { key_variant('split'), desc('Open `Lazy` File Horizontal Window') },
      ['<leader>Let'] = { key_variant('tabnew'), desc('Open `Lazy` File Tab') },
      ['<leader>Lev'] = { key_variant('vsplit'), desc('Open `Lazy`File Vertical Window') },
      ['<leader>Lh'] = { Lazy.health, desc('Run Lazy checkhealth') },
      ['<leader>Li'] = { Lazy.install, desc('Install Lazy Plugins') },
      ['<leader>Ll'] = { Lazy.show, desc('Show Lazy Home') },
      ['<leader>Lpb'] = { ':Lazy build ', desc('Prompt To Build', { silent = false }) },
      ['<leader>Lpl'] = { ':Lazy load ', desc('Prompt To Load', { silent = false }) },
      ['<leader>Lpr'] = { ':Lazy reload ', desc('Prompt To Reload', { silent = false }) },
      ['<leader>Ls'] = { Lazy.sync, desc('Sync Lazy Plugins') },
      ['<leader>Lu'] = { Lazy.update, desc('Update Lazy Plugins') },
      ['<leader>Lx'] = { Lazy.clear, desc('Clear Lazy Plugins') },
      ['<leader>vhL'] = { Lazy.health, desc('Run Lazy checkhealth') },
    },
  })
end

---@class Config.Lazy
local M = {}

---@return LazyPlugins specs
function M.get_default_specs()
  return { ---@type LazyPlugins
    Comment = { import = 'plugin.Comment' },
    alpha = { import = 'plugin.alpha' },
    autopairs = { import = 'plugin.autopairs' },
    barbar = { import = 'plugin.barbar' },
    blink = { import = 'plugin.blink.init' },
    blink_cmp = { import = 'plugin.blink.cmp' },
    blink_indent = { import = 'plugin.blink.indent' },
    blink_lib = { import = 'plugin.blink.lib' },
    blink_pairs = { import = 'plugin.blink.pairs' },
    boolean_toggle = { import = 'plugin.boolean-toggle' },
    bmessages = { import = 'plugin.bmessages' },
    bookmarks = { import = 'plugin.bookmarks' },
    buffer_sticks = { import = 'plugin.buffer-sticks' },
    bufferline = { import = 'plugin.bufferline' },
    ccc = { import = 'plugin.ccc' },
    cheaty = { import = 'plugin.cheaty' },
    checkmate = { import = 'plugin.checkmate' },
    classlayout = { import = 'plugin.classlayout' },
    code_runner = { import = 'plugin.code-runner' },
    codedocs = { import = 'plugin.codedocs' },
    syntax_codeowners = { import = 'plugin.syntax.codeowners' },
    syntax_gentoo = { import = 'plugin.syntax.gentoo' },
    syntax_tridactyl = { import = 'plugin.syntax.tridactyl' },
    color_skimer = { import = 'plugin.color-skimer' },
    colorschemes = { import = 'plugin.colorschemes' },
    colorizer = { import = 'plugin.colorizer' },
    conform = { import = 'plugin.conform' },
    copy_python_path = { import = 'plugin.copy-python-path' },
    diffview = { import = 'plugin.diffview' },
    dooku = { import = 'plugin.dooku' },
    doxygen = { import = 'plugin.doxygen.init' },
    doxygen_previewer = { import = 'plugin.doxygen.previewer' },
    drop = { import = 'plugin.drop' },
    echo = { import = 'plugin.echo' },
    flash = { import = 'plugin.flash' },
    fff = { import = 'plugin.fff' },
    focus = { import = 'plugin.focus' },
    fzf_lua = { import = 'plugin.fzf-lua' },
    fzf_nerdfont = { import = 'plugin.fzf-nerdfont' },
    git_co_author = { import = 'plugin.git.co-author' },
    git_gh_co = { import = 'plugin.git.gh-co' },
    git_ghactions = { import = 'plugin.git.gh-actions' },
    git_ghrelease = { import = 'plugin.git.ghrelease' },
    git_gitsigns = { import = 'plugin.git.gitsigns' },
    git_guh = { import = 'plugin.git.guh' },
    git_hunk = { import = 'plugin.git.hunk' },
    git_inlinediff = { import = 'plugin.git.inlinediff' },
    git_lazygit = { import = 'plugin.git.lazygit' },
    git_rehunk = { import = 'plugin.git.rehunk' },
    git_utils = { import = 'plugin.git.utils' },
    goto_preview = { import = 'plugin.goto-preview' },
    helpview = { import = 'plugin.helpview' },
    hlargs = { import = 'plugin.hlargs' },
    hoversplit = { import = 'plugin.hoversplit' },
    ibl = { import = 'plugin.ibl' },
    image = { import = 'plugin.image' },
    lastplace = { import = 'plugin.lastplace' },
    lazydev = { import = 'plugin.lazydev' },
    local_session = { import = 'plugin.local-session' },
    log_highlight = { import = 'plugin.log-highlight' },
    lsp = { import = 'plugin.lsp.init' },
    lsp_better_diagnostic = { import = 'plugin.lsp.better-diagnostic' },
    lsp_clangd = { import = 'plugin.lsp.clangd' },
    lsp_custom_diagnostic_highlight = { import = 'plugin.lsp.custom-diagnostic-highlight' },
    lsp_fidget = { import = 'plugin.lsp.fidget' },
    lsp_lspsaga = { import = 'plugin.lsp.lspsaga' },
    lsp_toggle = { import = 'plugin.lsp.toggle' },
    lspkind = { import = 'plugin.lspkind' },
    lualine = { import = 'plugin.lualine' },
    luaref = { import = 'plugin.luaref' },
    markdoc = { import = 'plugin.markdoc' },
    markdown = { import = 'plugin.markdown.init' },
    markdown_follow_md_links = { import = 'plugin.markdown.follow-md-links' },
    markdown_mdview = { import = 'plugin.markdown.mdview' },
    markdown_outline = { import = 'plugin.markdown.outline' },
    markdown_pipetable = { import = 'plugin.markdown.pipetable' },
    markdown_render = { import = 'plugin.markdown.render' },
    mason = { import = 'plugin.mason' },
    match = { import = 'plugin.match' },
    migrate = { import = 'plugin.migrate' },
    mini_animate = { import = 'plugin.mini.animate' },
    mini_basics = { import = 'plugin.mini.basics' },
    mini_base16 = { import = 'plugin.mini.base16' },
    mini_bufremove = { import = 'plugin.mini.bufremove' },
    mini_cmdline = { import = 'plugin.mini.cmdline' },
    mini_cursorword = { import = 'plugin.mini.cursorword' },
    mini_diff = { import = 'plugin.mini.diff' },
    mini_extra = { import = 'plugin.mini.extra' },
    mini_icons = { import = 'plugin.mini.icons' },
    mini_input = { import = 'plugin.mini.input' },
    mini_mini = { import = 'plugin.mini.mini' },
    mini_move = { import = 'plugin.mini.move' },
    mini_pairs = { import = 'plugin.mini.pairs' },
    mini_pick = { import = 'plugin.mini.pick' },
    mini_splitjoin = { import = 'plugin.mini.splitjoin' },
    mini_starter = { import = 'plugin.mini.starter' },
    mini_test = { import = 'plugin.mini.test' },
    mini_trailspace = { import = 'plugin.mini.trailspace' },
    music_player = { import = 'plugin.music-player' },
    neo_tree = { import = 'plugin.neo-tree' },
    neorg = { import = 'plugin.neorg' },
    noice = { import = 'plugin.noice' },
    notify = { import = 'plugin.notify' },
    nvim_test = { import = 'plugin.nvim-test' },
    nvim_tree = { import = 'plugin.nvim-tree' },
    oil = { import = 'plugin.oil.init' },
    oil_git = { import = 'plugin.oil.git' },
    orgmode = { import = 'plugin.orgmode' },
    outline = { import = 'plugin.outline' },
    paredit = { import = 'plugin.paredit' },
    persistence = { import = 'plugin.persistence' },
    picker = { import = 'plugin.picker' },
    pipenv = { import = 'plugin.pipenv' },
    pomo = { import = 'plugin.pomo' },
    pomodoro = { import = 'plugin.pomodoro' },
    possession = { import = 'plugin.possession' },
    precognition = { import = 'plugin.precognition' },
    project = { import = 'plugin.project' },
    python_import = { import = 'plugin.python.import' },
    rainbow_delimiters = { import = 'plugin.rainbow-delimiters' },
    real_icons = { import = 'plugin.real-icons' },
    record_key = { import = 'plugin.record-key' },
    refactoring = { import = 'plugin.refactoring' },
    refer = { import = 'plugin.refer' },
    referencer = { import = 'plugin.referencer' },
    replua = { import = 'plugin.replua' },
    scope = { import = 'plugin.scope' },
    screenkey = { import = 'plugin.screenkey' },
    scrollbar = { import = 'plugin.scrollbar' },
    shebang = { import = 'plugin.shebang' },
    smart_backspace = { import = 'plugin.smart-backspace' },
    smart_paste = { import = 'plugin.smart-paste' },
    smoothcursor = { import = 'plugin.smoothcursor' },
    snacks = { import = 'plugin.snacks' },
    spinner = { import = 'plugin.spinner' },
    startuptime = { import = 'plugin.startuptime' },
    styler = { import = 'plugin.styler' },
    stylua = { import = 'plugin.stylua' },
    telescope = { import = 'plugin.telescope.init' },
    tobira = { import = 'plugin.tobira' },
    todo = { import = 'plugin.todo' },
    todo_comments = { import = 'plugin.todo-comments' },
    tmux = { import = 'plugin.tmux' },
    toggleterm = { import = 'plugin.toggleterm' },
    toml = { import = 'plugin.toml' },
    triforce = { import = 'plugin.triforce' },
    trouble = { import = 'plugin.trouble' },
    ts_autotag = { import = 'plugin.ts.autotag' },
    ts_commentstring = { import = 'plugin.ts.commentstring' },
    ts_context = { import = 'plugin.ts.context' },
    ts_enable = { import = 'plugin.ts.enable' },
    ts_endwise = { import = 'plugin.ts.endwise' },
    ts = { import = 'plugin.ts.init' },
    ts_vimdoc = { import = 'plugin.ts.vimdoc' },
    twilight = { import = 'plugin.twilight' },
    web_devicons = { import = 'plugin.web-devicons' },
    wezterm_config = { import = 'plugin.wezterm-config' },
    which_colorscheme = { import = 'plugin.which-colorscheme' },
    which_key = { import = 'plugin.which-key' },
    window_picker = { import = 'plugin.window-picker' },
    yanky = { import = 'plugin.yanky' },
    zen_mode = { import = 'plugin.zen-mode' },
  }
end

function M.bootstrap()
  if vim.g.lazy_bootstrapped == 1 then
    return
  end

  if not (vim.uv or vim.loop).fs_stat(LAZYPATH) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', lazyrepo, LAZYPATH })
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
    diffview = false,
    dooku = false,
    doxygen = false,
    doxygen_previewer = true,
    drop = true,
    echo = false,
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
    lazydev = true,
    local_session = false,
    log_highlight = false,
    lsp = true,
    lsp_better_diagnostic = false,
    lsp_clangd = true,
    lsp_custom_diagnostic_highlight = true,
    lsp_fidget = true,
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
    orgmode = true,
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

  M.bootstrap()

  if vim.g.lazy_did_setup then
    return
  end

  local dict = M.get_default_specs()
  local dict_keys = vim.tbl_keys(dict) ---@type string[]
  local specs = {} ---@type (string|LazyPluginSpec|LazySpecImport)[]
  local err = ''
  for name, val in pairs(toggles) do
    if type(val) == 'boolean' then
      if vim.list_contains(dict_keys, name) and val then
        table.insert(specs, dict[name])
      elseif not vim.list_contains(dict_keys, name) then
        err = ('%s`%s` is not a valid toggle! Try adding the spec manually.\n'):format(err, name)
      end
    elseif type(val) == 'string' or type(val) == 'table' then
      table.insert(specs, val)
    else
      err = ('%sInvalid toggle/spec: `%s`'):format(err, vim.inspect(val))
    end
  end

  if err ~= '' then
    vim.schedule(function()
      vim.notify(err, vim.log.levels.WARN)
    end)
  end

  require('lazy').setup({
    change_detection = { enabled = true, notify = require('user_api').distro.archlinux.is_distro() },
    checker = {
      check_pinned = false,
      enabled = not require('user_api').distro.termux.is_distro(),
      frequency = 600,
      notify = not require('user_api').distro.termux.is_distro(),
    },
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
      sources = require('config.util').luarocks_check() and { 'lazy', 'packspec' }
        or { 'lazy', 'packspec', 'rockspec' },
      versions = true,
    },
    profiling = { loader = true, require = true },
    readme = {
      enabled = false,
      files = { 'README.md', 'lua/**/README.md' },
      root = README_PATH,
      skip_if_doc_exists = true,
    },
    rocks = {
      enabled = require('config.util').luarocks_check(),
      root = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy-rocks'),
    },
    root = LAZY_DATA,
    spec = specs,
    state = vim.fs.joinpath(LAZY_STATE, 'state.json'),
    ui = {
      backdrop = not require('user_api').check.in_console() and 70 or 100,
      border = 'double',
      pills = true,
      title = ('L%sA%sZ%sY'):format((' '):rep(12), (' '):rep(12), (' '):rep(12)),
      title_pos = 'center',
      wrap = true,
    },
  })

  setup_keys()
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
