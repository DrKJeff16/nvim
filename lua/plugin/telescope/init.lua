local floor = math.floor
local exists = require('user_api.check.exists').module
local desc = require('user_api.maps').desc

local Actions = require('telescope.actions')
local ActionsLayout = require('telescope.actions.layout')
local Config = require('telescope.config')

local vimgrep_arguments = { unpack(Config.values.vimgrep_arguments) }
local extra_args = { '--hidden', '--glob', '!**/.git/*', '!**/.ropeproject/*', '!**/.mypy_cache/*' }

for _, arg in ipairs(extra_args) do
  table.insert(vimgrep_arguments, arg)
end

local Opts = {
  defaults = {
    layout_strategy = 'flex',
    layout_config = {
      vertical = { width = floor(vim.o.columns * 3 / 4), height = floor(vim.o.lines * 5 / 6) },
      horizontal = {
        width = floor(vim.o.columns * 4 / 5),
        height = floor(vim.o.lines * 4 / 5),
      },
    },
    mappings = {
      i = {
        ['<C-?>'] = 'which_key',
        ['<C-u>'] = false,
        ['<C-d>'] = Actions.delete_buffer + Actions.move_to_top,
        ['<Esc>'] = Actions.close,
        ['<C-e>'] = Actions.close,
        ['<C-q>'] = Actions.close,
        ['<C-s>'] = Actions.cycle_previewers_next,
        ['<C-a>'] = Actions.cycle_previewers_prev,
        ['<M-p>'] = ActionsLayout.toggle_preview,
      },
      n = { ['<M-p>'] = ActionsLayout.toggle_preview },
    },
    vimgrep_arguments = vimgrep_arguments,
    preview = { filesize_limit = 0.75 },
  },
  extensions = {
    persisted = { layout_config = { width = 0.75, height = 0.75 } },
    projects = { prompt_prefix = '󱎸  ' },
    undo = {
      use_delta = true,
      use_custom_command = nil,
      side_by_side = true,
      layout_strategy = 'vertical',
      layout_config = { preview_height = 0.8 },
      vim_diff_opts = { ctxlen = vim.o.scrolloff },
      entry_format = 'state #$ID, $STAT, $TIME',
      time_format = '',
      saved_only = false,
      mappings = {
        i = {
          ['<CR>'] = require('telescope-undo.actions').yank_additions,
          ['<S-CR>'] = require('telescope-undo.actions').yank_deletions,
          ['<C-CR>'] = require('telescope-undo.actions').restore,
          ['<C-y>'] = require('telescope-undo.actions').yank_deletions,
          ['<C-r>'] = require('telescope-undo.actions').restore,
        },
        n = {
          y = require('telescope-undo.actions').yank_additions,
          Y = require('telescope-undo.actions').yank_deletions,
          u = require('telescope-undo.actions').restore,
        },
      },
    },
  },
  pickers = {
    autocommands = { theme = 'dropdown' },
    buffers = { theme = 'dropdown' },
    colorscheme = { theme = 'dropdown' },
    commands = { theme = 'ivy' },
    current_buffer_fuzzy_find = { theme = 'dropdown' },
    fd = { theme = 'ivy' },
    find_files = {
      theme = 'ivy',
      find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
    },
    git_branches = { theme = 'dropdown' },
    git_status = { theme = 'dropdown' },
    git_stash = { theme = 'dropdown' },
    highlights = { theme = 'dropdown' },
    lsp_definitions = { theme = 'cursor' },
    lsp_document_symbols = { theme = 'cursor' },
    lsp_implementations = { theme = 'cursor' },
    lsp_type_definitions = { theme = 'cursor' },
    lsp_workspace_symbols = { theme = 'cursor' },
    man_pages = { theme = 'dropdown' },
    pickers = { theme = 'ivy' },
    planets = { theme = 'ivy' },
    vim_options = { theme = 'ivy' },
  },
}

if exists('trouble.sources.telescope') then
  local open_with_trouble = require('trouble.sources.telescope').open
  Opts.defaults.mappings.i['<C-T>'] = open_with_trouble
  Opts.defaults.mappings.n['<C-T>'] = open_with_trouble
end
if require('plugin.telescope.file_browser') then
  Opts.extensions.file_browser = require('plugin.telescope.file_browser').file_browser
  require('plugin.telescope.file_browser').loadkeys()
end
if require('plugin.telescope.cc') then
  Opts.extensions.conventional_commits = require('plugin.telescope.cc').cc
  require('plugin.telescope.cc').loadkeys()
end
if require('plugin.telescope.tabs') then
  require('plugin.telescope.tabs').create()
  require('plugin.telescope.tabs').loadkeys()
end

require('telescope').setup(Opts)

local function load_ext(name) ---@param name string
  require('telescope').load_extension(name)
  -- Make sure `picker_list` doesn't load itself
  if name == 'picker_list' then
    vim.g.telescope_picker_list_loaded = 1
    return
  end
  -- If `picker_list` is loaded, also register extension with it
  if exists('telescope._extensions.picker_list.main') then
    require('telescope._extensions.picker_list.main').register(name)
  end
end

local Keys = { ---@type AllMaps
  ['<leader><C-t>'] = { group = '+Telescope' },
  ['<leader><C-t>b'] = { group = '+Builtins' },
  ['<leader><C-t>e'] = { group = '+Extensions' },
  ['<leader>HH'] = { ':Telescope help_tags<CR>', desc('Telescope Help Tags') },
  ['<leader>HM'] = { ':Telescope man_pages<CR>', desc('Telescope Man Pages') },
  ['<leader>GB'] = { ':Telescope git_branches<CR>', desc('Telescope Git Branches') },
  ['<leader>GS'] = { ':Telescope git_stash<CR>', desc('Telescope Git Stash') },
  ['<leader>Gs'] = { ':Telescope git_status<CR>', desc('Telescope Git Status') },
  ['<leader>bB'] = { ':Telescope buffers<CR>', desc('Telescope Buffers') },
  ['<leader>fD'] = { ':Telescope diagnostics<CR>', desc('Telescope Diagnostics') },
  ['<leader>ff'] = { ':Telescope find_files<CR>', desc('Telescope File Picker') },
  ['<leader>lD'] = { ':Telescope lsp_document_symbols<CR>', desc('Telescope Document Symbols') },
  ['<leader>lT'] = { ':Telescope lsp_type_definitions<CR>', desc('Telescope Definitions') },
  ['<leader>ld'] = { ':Telescope lsp_definitions<CR>', desc('Telescope Definitions') },
  ['<leader>li'] = { ':Telescope lsp_implementations<CR>', desc('Telelcope Lsp Implementations') },
  ['<leader>lwD'] = {
    ':Telescope lsp_dynamic_workspace_symbols<CR>',
    desc('Telescope Dynamic Symbols'),
  },
  ['<leader>lwd'] = {
    ':Telescope lsp_workspace_symbols<CR>',
    desc('Telescope Workspace Symbols'),
  },
  ['<leader>vK'] = { ':Telescope keymaps<CR>', desc('Telescope Keymaps') },
  ['<leader>vO'] = { ':Telescope vim_options<CR>', desc('Telescope Vim Options') },
  ['<leader>uC'] = { ':Telescope colorscheme<CR>', desc('Telescope Colorschemes') },
  ['<leader><C-t>b/'] = { ':Telescope current_buffer_fuzzy_find<CR>', desc('Buffer Fuzzy-Find') },
  ['<leader><C-t>bA'] = { ':Telescope autocommands<CR>', desc('Autocommands') },
  ['<leader><C-t>bC'] = { ':Telescope commands<CR>', desc('Commands') },
  ['<leader><C-t>bg'] = { ':Telescope live_grep<CR>', desc('Live Grep') },
  ['<leader><C-t>bh'] = { ':Telescope highlights<CR>', desc('Highlights') },
  ['<leader><C-t>bp'] = { ':Telescope pickers<CR>', desc('Pickers') },
}

local known_exts = { ---@type table<string, { [1]: string, keys?: AllMaps }>
  ['telescope._extensions.file_browser'] = { 'file_browser' },
  ['telescope._extensions.heading'] = {
    'heading',
    keys = { ['<leader><C-t>eh'] = { ':Telescope heading<CR>', desc('Heading Picker') } },
  },
  ['telescope._extensions.lazy_plugins'] = { 'lazy_plugins' },
  ['telescope._extensions.undo'] = {
    'undo',
    keys = {
      ['<leader><C-t>eu'] = { ':Telescope undo<CR>', desc('Undo Picker') },
      ['<leader>fu'] = { ':Telescope undo<CR>', desc('Undo Telescope Picker') },
    },
  },
  ['plugin.telescope.cc'] = {
    'conventional_commits',
    keys = {
      ['<leader><C-t>eC'] = {
        ':Telescope conventional_commits<CR>',
        desc('Conventional Commits'),
      },
      ['<leader>GC'] = {
        ':Telescope conventional_commits<CR>',
        desc('Conventional Commits (Telescope)'),
      },
    },
  },
  ['telescope-makefile'] = {
    'make',
    keys = {
      ['<leader>fM'] = { group = '+Make' },
      ['<leader>fMT'] = { ':Telescope make<CR>', desc('Makefile Telescope Picker') },
      ['<leader><C-t>eM'] = { ':Telescope make<CR>', desc('Makefile Picker') },
    },
  },
  ['lazygit.utils'] = {
    'lazygit',
    keys = {
      ['<leader><C-t>eG'] = { ':Telescope lazygit<CR>', desc('LazyGit Picker') },
      ['<leader>GlT'] = { ':Telescope lazygit<CR>', desc('LazyGit Telescope Picker') },
    },
  },
  ['telescope._extensions.picker_list'] = {
    'picker_list',
    keys = {
      ['<leader><C-t>eP'] = { ':Telescope picker_list<CR>', desc('Picker List') },
      ['<leader><C-t>bp'] = { ':Telescope picker_list<CR>', desc('Picker List (Extension)') },
    },
  },
}
for mod, ext in pairs(known_exts) do
  local extension = ext[1] or ''
  if exists(mod) and extension ~= '' then
    load_ext(extension)
    if ext.keys then
      for lhs, v in pairs(ext.keys) do
        Keys[lhs] = v
      end
    end
  end
end
require('user_api.config').keymaps.set({ n = Keys })

vim.api.nvim_create_autocommand('User', {
  group = vim.api.nvim_create_augroup('UserTelescope', { clear = true }),
  pattern = 'TelescopePreviewerLoaded',
  callback = function(ev)
    local win_opts = { win = vim.api.nvim_get_current_win() } ---@type vim.api.keyset.option
    if ev.data.filetype ~= 'help' then
      vim.api.nvim_set_option_value('number', true, win_opts)
    elseif ev.data.bufname:match('*.csv') then
      vim.api.nvim_set_option_value('wrap', false, win_opts)
    end
  end,
})
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
