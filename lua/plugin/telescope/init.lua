---@module 'lazy'

---@param picker string
---@return function map_cmd
local function run_map(picker)
  require('user_api.check').validate({ picker = { picker, { 'string' } } })

  return function()
    vim.cmd.Telescope(picker)
  end
end

return { ---@type LazySpec
  'nvim-telescope/telescope.nvim',
  version = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'OliverChao/telescope-picker-list.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    { 'polirritmico/telescope-lazy-plugins.nvim', dev = true },
  },
  config = function()
    local exists = require('user_api.check.exists').module

    local Actions = require('telescope.actions')
    local ActionsLayout = require('telescope.actions.layout')
    local Config = require('telescope.config')

    local vimgrep_arguments = { unpack(Config.values.vimgrep_arguments) }
    local extra_args = {
      '--hidden',
      '--glob',
      '!**/.git/*',
      '!**/.ropeproject/*',
      '!**/.mypy_cache/*',
    }

    for _, arg in ipairs(extra_args) do
      table.insert(vimgrep_arguments, arg)
    end
    local Opts = {
      defaults = {
        layout_strategy = 'flex',
        layout_config = {
          vertical = {
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.85),
          },
          horizontal = {
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.8),
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
      extensions = { projects = { prompt_prefix = '󱎸  ' } },
      pickers = {
        autocommands = { theme = 'dropdown' },
        buffers = { theme = 'dropdown' },
        colorscheme = { theme = 'dropdown' },
        commands = { theme = 'dropdown' },
        current_buffer_fuzzy_find = { theme = 'dropdown' },
        fd = { theme = 'dropdown' },
        find_files = {
          theme = 'dropdown',
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
        pickers = { theme = 'dropdown' },
        planets = { theme = 'dropdown' },
        vim_options = { theme = 'dropdown' },
      },
    }

    if exists('trouble.sources.telescope') then
      local open_with_trouble = require('trouble.sources.telescope').open
      Opts.defaults.mappings.i['<C-T>'] = open_with_trouble
      Opts.defaults.mappings.n['<C-T>'] = open_with_trouble
    end
    if exists('plugin.telescope.file_browser') then
      Opts.extensions.file_browser = require('plugin.telescope.file_browser').file_browser
      require('plugin.telescope.file_browser').loadkeys()
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

    local desc = require('user_api.maps').desc
    local Keys = { ---@type AllMaps
      ['<leader><C-t>'] = { group = '+Telescope' },
      ['<leader><C-t>b'] = { group = '+Builtins' },
      ['<leader><C-t>e'] = { group = '+Extensions' },
      ['<leader>HH'] = { run_map('help_tags'), desc('Telescope Help Tags') },
      ['<leader>HM'] = { run_map('man_pages'), desc('Telescope Man Pages') },
      ['<leader>GB'] = { run_map('git_branches'), desc('Telescope Git Branches') },
      ['<leader>GS'] = { run_map('git_stash'), desc('Telescope Git Stash') },
      ['<leader>Gs'] = { run_map('git_status'), desc('Telescope Git Status') },
      ['<leader>bB'] = { run_map('buffers'), desc('Telescope Buffers') },
      ['<leader>fD'] = { run_map('diagnostics'), desc('Telescope Diagnostics') },
      ['<leader>ff'] = { run_map('find_files'), desc('Telescope File Picker') },
      ['<leader>vK'] = { run_map('keymaps'), desc('Telescope Keymaps') },
      ['<leader>vO'] = { run_map('vim_options'), desc('Telescope Vim Options') },
      ['<leader>uC'] = { run_map('colorscheme'), desc('Telescope Colorschemes') },
      ['<leader><C-t>bA'] = { run_map('autocommands'), desc('Autocommands') },
      ['<leader><C-t>bC'] = { run_map('commands'), desc('Commands') },
      ['<leader><C-t>bg'] = { run_map('live_grep'), desc('Live Grep') },
      ['<leader><C-t>bh'] = { run_map('highlights'), desc('Highlights') },
      ['<leader><C-t>bp'] = { run_map('pickers'), desc('Pickers') },
    }

    local known_exts = { ---@type table<string, { [1]: string, keys?: AllMaps }>
      ['telescope._extensions.file_browser'] = { 'file_browser' },
      ['telescope._extensions.lazy_plugins'] = { 'lazy_plugins' },
      ['lazygit.utils'] = {
        'lazygit',
        keys = {
          ['<leader><C-t>eG'] = { run_map('lazygit'), desc('LazyGit Picker') },
          ['<leader>GlT'] = { run_map('lazygit'), desc('LazyGit Telescope Picker') },
        },
      },
      ['telescope._extensions.picker_list'] = {
        'picker_list',
        keys = { ['<leader><C-t>eP'] = { run_map('picker_list'), desc('Picker List') } },
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

    require('user_api.config.keymaps').set({ n = Keys })

    vim.api.nvim_create_autocmd('User', {
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
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
