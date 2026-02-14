---@module 'config._meta'

local MODSTR = 'config.lazy'
local WARN = vim.log.levels.WARN
local LAZY_DATA = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
local LAZY_STATE = vim.fs.joinpath(vim.fn.stdpath('state'), 'lazy')
local LAZYPATH = vim.fs.joinpath(LAZY_DATA, 'lazy.nvim')
local README_PATH = vim.fs.joinpath(LAZY_STATE, 'readme')
local key_variant = require('config.util').key_variant

---@class Config.Lazy
local M = {}

---@return LazyPlugins spec
function M.get_default_specs()
  return { ---@type LazyPlugins
    Comment = { import = 'plugin.Comment' },
    _spec = { import = 'plugin._spec' },
    alpha = { import = 'plugin.alpha' },
    autopairs = { import = 'plugin.autopairs' },
    blink_cmp = { import = 'plugin.blink.cmp' },
    blink_indent = { import = 'plugin.blink.indent' },
    blink_pairs = { import = 'plugin.blink.pairs' },
    bmessages = { import = 'plugin.bmessages' },
    buffer_sticks = { import = 'plugin.buffer-sticks' },
    bufferline = { import = 'plugin.bufferline' },
    cheaty = { import = 'plugin.cheaty' },
    checkmate = { import = 'plugin.checkmate' },
    co_author = { import = 'plugin.co-author' },
    code_runner = { import = 'plugin.code-runner' },
    codeowners = { import = 'plugin.codeowners' },
    diffview = { import = 'plugin.diffview' },
    dooku = { import = 'plugin.dooku' },
    doxygen_init = { import = 'plugin.doxygen.init' },
    doxygen_previewer = { import = 'plugin.doxygen.previewer' },
    echo = { import = 'plugin.echo' },
    focus = { import = 'plugin.focus' },
    fzf_lua = { import = 'plugin.fzf-lua' },
    fzf_nerdfont = { import = 'plugin.fzf-nerdfont' },
    gh_co = { import = 'plugin.gh-co' },
    git_gitsigns = { import = 'plugin.git.gitsigns' },
    git_inlinediff = { import = 'plugin.git.inlinediff' },
    git_lazygit = { import = 'plugin.git.lazygit' },
    git_rehunk = { import = 'plugin.git.rehunk' },
    git_utils = { import = 'plugin.git.utils' },
    goto_preview = { import = 'plugin.goto-preview' },
    helpview = { import = 'plugin.helpview' },
    hlargs = { import = 'plugin.hlargs' },
    hoversplit = { import = 'plugin.hoversplit' },
    ibl = { import = 'plugin.ibl' },
    lastplace = { import = 'plugin.lastplace' },
    lazydev = { import = 'plugin.lazydev' },
    local_session = { import = 'plugin.local-session' },
    log_highlight = { import = 'plugin.log-highlight' },
    lsp = { import = 'plugin.lsp.init' },
    lsp_better_diagnostic = { import = 'plugin.lsp.better-diagnostic' },
    lsp_clangd = { import = 'plugin.lsp.clangd' },
    lsp_toggle = { import = 'plugin.lsp-toggle' },
    lspkind = { import = 'plugin.lspkind' },
    lualine = { import = 'plugin.lualine' },
    luaref = { import = 'plugin.luaref' },
    markdoc = { import = 'plugin.markdoc' },
    markdown_outline = { import = 'plugin.markdown.outline' },
    markdown_render = { import = 'plugin.markdown.render' },
    mason = { import = 'plugin.mason' },
    mini_animate = { import = 'plugin.mini.animate' },
    mini_basics = { import = 'plugin.mini.basics' },
    mini_bufremove = { import = 'plugin.mini.bufremove' },
    mini_cmdline = { import = 'plugin.mini.cmdline' },
    mini_diff = { import = 'plugin.mini.diff' },
    mini_extra = { import = 'plugin.mini.extra' },
    mini_icons = { import = 'plugin.mini.icons' },
    mini_mini = { import = 'plugin.mini.mini' },
    mini_move = { import = 'plugin.mini.move' },
    mini_pairs = { import = 'plugin.mini.pairs' },
    mini_splitjoin = { import = 'plugin.mini.splitjoin' },
    mini_starter = { import = 'plugin.mini.starter' },
    mini_test = { import = 'plugin.mini.test' },
    mini_trailspace = { import = 'plugin.mini.trailspace' },
    music_player = { import = 'plugin.music-player' },
    neo_tree = { import = 'plugin.neo-tree' },
    noice = { import = 'plugin.noice' },
    notify = { import = 'plugin.notify' },
    nvim_test = { import = 'plugin.nvim-test' },
    orgmode = { import = 'plugin.orgmode' },
    outline = { import = 'plugin.outline' },
    paredit = { import = 'plugin.paredit' },
    persistence = { import = 'plugin.persistence' },
    picker = { import = 'plugin.picker' },
    pipenv = { import = 'plugin.pipenv' },
    pomo = { import = 'plugin.pomo' },
    possession = { import = 'plugin.possession' },
    project = { import = 'plugin.project' },
    python_import = { import = 'plugin.python.import' },
    rainbow_delimiters = { import = 'plugin.rainbow-delimiters' },
    refactoring = { import = 'plugin.refactoring' },
    referencer = { import = 'plugin.referencer' },
    replua = { import = 'plugin.replua' },
    scope = { import = 'plugin.scope' },
    screenkey = { import = 'plugin.screenkey' },
    scrollbar = { import = 'plugin.scrollbar' },
    smart_backspace = { import = 'plugin.smart-backspace' },
    smart_paste = { import = 'plugin.smart-paste' },
    smoothcursor = { import = 'plugin.smoothcursor' },
    snacks = { import = 'plugin.snacks' },
    spinner = { import = 'plugin.spinner' },
    startuptime = { import = 'plugin.startuptime' },
    telescope = { import = 'plugin.telescope.init' },
    todo_comments = { import = 'plugin.todo-comments' },
    toggleterm = { import = 'plugin.toggleterm' },
    toml = { import = 'plugin.toml' },
    triforce = { import = 'plugin.triforce' },
    trouble = { import = 'plugin.trouble' },
    ts_autotag = { import = 'plugin.ts.autotag' },
    ts_commentstring = { import = 'plugin.ts.commentstring' },
    ts_context = { import = 'plugin.ts.context' },
    ts_init = { import = 'plugin.ts.init' },
    ts_vimdoc = { import = 'plugin.ts.vimdoc' },
    twilight = { import = 'plugin.twilight' },
    undotree = { import = 'plugin.undotree' },
    wezterm_config = { import = 'plugin.wezterm-config' },
    web_devicons = { import = 'plugin.web-devicons' },
    which_colorscheme = { import = 'plugin.which-colorscheme' },
    which_key = { import = 'plugin.which-key' },
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
        { ('(%s): Failed to clone lazy.nvim:\n'):format(MODSTR), 'ErrorMsg' },
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

function M.setup_keys()
  local desc = require('user_api.maps').desc
  local lazy = require('lazy')
  require('user_api.config').keymaps.set({
    n = {
      ['<leader>L'] = { group = '+Lazy' },
      ['<leader>Le'] = { group = '+Edit Lazy File' },
      ['<leader>Lee'] = { key_variant('edit'), desc('Open `Lazy` File') },
      ['<leader>Les'] = { key_variant('split'), desc('Open `Lazy` File Horizontal Window') },
      ['<leader>Let'] = { key_variant('tabnew'), desc('Open `Lazy` File Tab') },
      ['<leader>Lev'] = { key_variant('vsplit'), desc('Open `Lazy`File Vertical Window') },
      ['<leader>Ll'] = { lazy.show, desc('Show Lazy Home') },
      ['<leader>Ls'] = { lazy.sync, desc('Sync Lazy Plugins') },
      ['<leader>Lx'] = { lazy.clear, desc('Clear Lazy Plugins') },
      ['<leader>Lc'] = { lazy.check, desc('Check Lazy Plugins') },
      ['<leader>Li'] = { lazy.install, desc('Install Lazy Plugins') },
      ['<leader>Lh'] = { lazy.health, desc('Run Lazy checkhealth') },
      ['<leader>vhL'] = { lazy.health, desc('Run Lazy checkhealth') },
      ['<leader>L<CR>'] = { ':Lazy ', desc('Select `Lazy` Operation (Interactively)', false) },
      ['<leader>Lb'] = { ':Lazy build ', desc('Prompt To Build', false) },
      ['<leader>Lr'] = { ':Lazy reload ', desc('Prompt To Build', false) },
    },
  })
end

---@return LazyToggles
function M.get_default_toggles()
  return { ---@type LazyToggles
    Comment = true,
    alpha = false,
    autopairs = true,
    blink_cmp = true,
    blink_pairs = true,
    bmessages = true,
    bufferline = true,
    codeowners = true,
    focus = true,
    fzf_lua = true,
    git_gitsigns = true,
    git_inlinediff = true,
    git_lazygit = false,
    git_rehunk = true,
    git_utils = true,
    goto_preview = true,
    helpview = true,
    hlargs = false,
    hoversplit = true,
    ibl = true,
    lastplace = true,
    lazydev = true,
    lsp = true,
    lsp_clangd = true,
    lspkind = true,
    lualine = true,
    luaref = true,
    markdown_render = true,
    mason = true,
    mini_basics = true,
    mini_bufremove = true,
    mini_cmdline = true,
    mini_diff = false,
    mini_extra = true,
    mini_icons = true,
    mini_mini = true,
    mini_move = true,
    mini_splitjoin = true,
    mini_starter = true,
    mini_trailspace = true,
    music_player = true,
    neo_tree = true,
    noice = true,
    notify = true,
    outline = true,
    paredit = true,
    persistence = true,
    pipenv = true,
    project = true,
    python_import = true,
    rainbow_delimiters = true,
    scope = true,
    screenkey = true,
    smart_backspace = true,
    smart_paste = true,
    smoothcursor = true,
    snacks = true,
    spinner = true,
    startuptime = true,
    telescope = true,
    todo_comments = true,
    toggleterm = true,
    toml = true,
    triforce = true,
    trouble = true,
    ts_autotag = true,
    ts_commentstring = true,
    ts_context = true,
    ts_init = true,
    ts_vimdoc = true,
    wezterm_config = false,
    web_devicons = true,
    which_colorscheme = true,
    which_key = true,
    yanky = true,
  }
end

---Sets up `lazy.nvim`. Only runs once!
--- ---
---@param toggles? table<integer, LazySpec>|LazyToggles|LazyPluginSpec
function M.setup(toggles)
  require('user_api.check').validate({ toggles = { toggles, { 'table', 'nil' }, true } })
  toggles = vim.tbl_deep_extend('keep', toggles or {}, M.get_default_toggles())

  M.bootstrap()

  if vim.g.lazy_did_setup then
    return
  end

  local dict = M.get_default_specs()
  local dict_keys = vim.tbl_keys(dict) ---@type string[]
  local specs = { { import = 'plugin._spec' } } ---@type (string|LazyPluginSpec|LazySpecImport)[]
  local err = ''
  for name, val in pairs(toggles) do
    if type(val) == 'boolean' then
      ---@cast val boolean
      if vim.tbl_contains(dict_keys, name) then
        if val then
          table.insert(specs, dict[name])
        end
      else
        err = ('%s`%s` is not a valid toggle! Try adding the spec manually.\n'):format(err, name)
      end
    elseif vim.list_contains({ 'string', 'table' }, type(val)) then
      ---@cast val LazyPluginSpec|LazySpecImport|string
      table.insert(specs, val)
    else
      err = ('%sInvalid toggle/spec: `%s`'):format(err, vim.inspect(val))
    end
  end

  if err ~= '' then
    vim.schedule(function()
      vim.notify(err, WARN)
    end)
  end

  require('lazy').setup({
    spec = specs,
    root = LAZY_DATA,
    defaults = { lazy = false, version = false },
    install = { colorscheme = { 'habamax' }, missing = true },
    dev = { path = '~/Projects/nvim', patterns = {}, fallback = true },
    change_detection = {
      enabled = true,
      notify = require('user_api.distro.archlinux').is_distro(),
    },
    performance = {
      reset_packpath = true,
      rtp = {
        reset = true,
        disabled_plugins = {
          -- 'gzip',
          -- 'matchit',
          -- 'matchparen',
          'netrwPlugin',
          -- 'tarPlugin',
          'tohtml',
          'tutor',
          -- 'zipPlugin',
        },
      },
    },
    rocks = {
      enabled = require('config.util').luarocks_check(),
      root = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy-rocks'),
    },
    pkg = {
      enabled = true,
      cache = vim.fs.joinpath(LAZY_STATE, 'pkg-cache.lua'),
      versions = true,
      sources = require('config.util').luarocks_check() and { 'lazy', 'packspec' }
        or { 'lazy', 'packspec', 'rockspec' },
    },
    checker = {
      enabled = not require('user_api.distro.termux').is_distro(),
      notify = not require('user_api.distro.termux').is_distro(),
      frequency = 600,
      check_pinned = false,
    },
    ui = {
      backdrop = not require('user_api.check').in_console() and 60 or 100,
      border = 'double',
      title = ('L%sA%sZ%sY'):format((' '):rep(12), (' '):rep(12), (' '):rep(12)),
      title_pos = 'center',
      wrap = true,
      pills = true,
    },
    readme = {
      enabled = false,
      root = README_PATH,
      files = { 'README.md', 'lua/**/README.md' },
      skip_if_doc_exists = true,
    },
    state = vim.fs.joinpath(LAZY_STATE, 'state.json'),
    profiling = { loader = true, require = true },
    debug = false,
    headless = { colors = true, log = true, process = true, task = true },
  })

  M.setup_keys()
end

local Lazy = setmetatable(M, { ---@type Config.Lazy
  __index = M,
  __newindex = function()
    vim.notify('Config.Lazy is Read-Only!', vim.log.levels.ERROR)
  end,
})

return Lazy
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
