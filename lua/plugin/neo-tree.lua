---@module 'lazy'
return { ---@type LazySpec
  'nvim-neo-tree/neo-tree.nvim',
  version = false,
  event = 'VeryLazy',
  dependencies = {
    { 'DrKJeff16/plenary.nvim', dev = true },
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    'saifulapm/neotree-file-nesting-config',
    {
      'Crysthamus/nvim-file-operations',
      dev = true,
      config = function()
        require('nvim-file-operations').setup({
          auto_save = false,
          operations = {
            didCreateFiles = true,
            didDeleteFiles = true,
            didRenameFiles = true,
            willCreateFiles = true,
            willDeleteFiles = true,
            willRenameFiles = true,
          },
          timeout_ms = 10000,
        })
      end,
    },
    { 'mrbjarksen/neo-tree-diagnostics.nvim', main = 'neo-tree.sources.diagnostics' },
    {
      's1n7ax/nvim-window-picker',
      version = false,
      config = function()
        require('window-picker').setup({
          filter_rules = {
            autoselect_one = true,
            bo = { buftype = { 'terminal', 'quickfix' }, filetype = { 'neo-tree', 'neo-tree-popup', 'notify' } },
            include_current_win = false,
          },
        })
      end,
    },
  },
  config = function()
    require('neo-tree').setup({
      clipboard = { sync = 'global' },
      close_if_last_window = false,
      enable_diagnostics = true,
      enable_git_status = true,
      hide_root_node = true,
      nesting_rules = require('neotree-file-nesting-config').nesting_rules,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      open_files_using_relative_paths = false,
      popup_border_style = 'NC',
      retain_hidden_root_indent = true,
      sort_case_insensitive = false,
      sources = { 'filesystem', 'buffers', 'git_status', 'diagnostics' },
      event_handlers = {
        {
          event = 'file_open_requested',
          handler = function()
            require('neo-tree.command').execute({ action = 'close' })
          end,
        },
        {
          event = 'after_render',
          handler = function(state)
            if not vim.list_contains({ 'left', 'right' }, state.current_position) then
              return
            end
            vim.api.nvim_win_call(state.winid, function()
              local str = require('neo-tree.ui.selector').get()
              if str then
                _G.__cached_neo_tree_selector = str
              end
            end)
          end,
        },
        {
          event = 'neo_tree_window_after_open',
          handler = function(args)
            if vim.list_contains({ 'left', 'right' }, args.position) then
              vim.cmd.wincmd('=')
            end
          end,
        },
        {
          event = 'neo_tree_window_after_close',
          handler = function(args)
            if vim.list_contains({ 'left', 'right' }, args.position) then
              vim.cmd.wincmd('=')
            end
          end,
        },
      },
      diagnostics = {
        auto_preview = { enabled = true, preview_config = { float = true }, event = 'neo_tree_window_after_open' },
        bind_to_cwd = true,
        diag_sort_function = 'severity',
        follow_current_file = {
          enabled = true,
          always_focus_file = true,
          expand_followed = true,
          leave_dirs_open = false,
          leave_files_open = false,
        },
        group_dirs_and_files = true,
        group_empty_dirs = true,
        refresh = { delay = 500, event = 'vim_diagnostic_changed', max_items = 10000 },
        show_unloaded = true,
      },
      default_component_configs = {
        container = { enable_character_fade = true },
        diagnostics = {
          highlights = {
            error = 'DiagnosticSignError',
            hint = 'DiagnosticSignHint',
            info = 'DiagnosticSignInfo',
            warn = 'DiagnosticSignWarn',
          },
          symbols = { hint = 'H', info = 'I', warn = '!', error = 'X' },
        },
        icon = {
          selected = '*',
          use_filtered_colors = true,
          folder_closed = '',
          folder_open = '',
          folder_empty = '󰜌',
          folder_empty_open = '',
          default = '*',
          highlight = 'NeoTreeFileIcon',
          ---@param icon table
          ---@param node table
          provider = function(icon, node)
            if node.type == 'file' or node.type == 'terminal' then
              local name = node.type == 'terminal' and 'terminal' or node.name
              local devicon, hl = require('nvim-web-devicons').get_icon(name)
              icon.text = devicon or icon.text
              icon.highlight = hl or icon.highlight
            end
          end,
        },
        indent = {
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
          highlight = 'NeoTreeIndentMarker',
          indent_marker = '│',
          indent_size = 2,
          last_indent_marker = '└',
          padding = 1,
          with_markers = true,
        },
        modified = { symbol = '[+]', highlight = 'NeoTreeModified' },
        name = {
          highlight = 'NeoTreeFileName',
          trailing_slash = true,
          use_filtered_colors = true,
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            added = '✚',
            conflict = '',
            deleted = '✖',
            ignored = '',
            modified = '',
            renamed = '󰁕',
            staged = '',
            unstaged = '󰄱',
            untracked = '',
          },
        },
        created = { enabled = false, width = 20, required_width = 110 }, ---@diagnostic disable-line:missing-fields
        file_size = { enabled = false, width = 12, required_width = 64 },
        last_modified = { enabled = false, width = 20, required_width = 88 }, ---@diagnostic disable-line:missing-fields
        symlink_target = { enabled = true },
        type = { enabled = true, width = 10, required_width = 122 },
      },
      commands = {},
      window = {
        position = 'left',
        width = 40,
        mapping_options = { noremap = true, nowait = true },
        mappings = {
          ['<Tab>'] = function(state)
            state.commands.open(state)
            vim.cmd.Neotree('reveal')
          end,
          ['<CR>'] = 'open',
          ['<Esc>'] = 'cancel',
          P = { 'toggle_preview', config = { use_float = true, use_snacks_image = false, use_image_nvim = false } },
          l = 'focus_preview',
          S = 'open_split',
          s = 'open_vsplit',
          t = 'open_tabnew',
          w = 'open_with_window_picker',
          C = 'close_node',
          z = 'close_all_nodes',
          Z = 'expand_all_subnodes',
          a = { 'add', config = { show_path = 'absolute' } },
          A = 'add_directory',
          d = 'delete',
          r = 'rename',
          b = 'rename_basename',
          y = 'copy_to_clipboard',
          x = 'cut_to_clipboard',
          p = 'paste_from_clipboard',
          c = { 'copy', config = { show_path = 'absolute' } },
          m = 'move',
          q = 'close_window',
          R = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
          i = {
            'show_file_details',
            config = {
              created_format = '%Y-%m-%d %I:%M %p',
              modified_format = function(seconds) ---@param seconds integer
                return require('neo-tree.utils').relative_date(seconds)
              end,
            },
          },
        },
      },
      filesystem = {
        filtered_items = {
          always_show = {},
          always_show_by_pattern = {},
          hide_by_name = { 'node_modules' },
          hide_by_pattern = {},
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          never_show = { '.DS_Store', 'thumbs.db' },
          never_show_by_pattern = {},
          show_hidden_count = false,
          visible = false,
        },
        follow_current_file = { enabled = true, leave_dirs_open = false },
        group_empty_dirs = true,
        hijack_netrw_behavior = 'open_default',
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ['<BS>'] = 'navigate_up',
            ['.'] = 'set_root',
            H = 'toggle_hidden',
            ['/'] = 'fuzzy_finder',
            D = 'fuzzy_finder_directory', ---@type 'fuzzy_sorter_directory'|'fuzzy_finder_directory'
            ['#'] = 'fuzzy_sorter',
            f = 'filter_on_submit',
            ['<c-x>'] = 'clear_filter',
            ['[g'] = 'prev_git_modified',
            [']g'] = 'next_git_modified',
            o = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            oc = { 'order_by_created', nowait = false },
            od = { 'order_by_diagnostics', nowait = false },
            og = { 'order_by_git_status', nowait = false },
            om = { 'order_by_modified', nowait = false },
            on = { 'order_by_name', nowait = false },
            os = { 'order_by_size', nowait = false },
            ot = { 'order_by_type', nowait = false },
          },
          fuzzy_finder_mappings = {
            ['<C-CR>'] = 'close_clear_filter',
            ['<C-n>'] = 'move_cursor_down',
            ['<C-p>'] = 'move_cursor_up',
            ['<C-w>'] = { '<C-S-w>', raw = true },
            ['<Down>'] = 'move_cursor_down',
            ['<Esc>'] = 'close',
            ['<S-CR>'] = 'close_keep_filter',
            ['<Up>'] = 'move_cursor_up',
            {
              n = {
                ['<C-CR>'] = 'close_clear_filter',
                ['<Esc>'] = 'close',
                ['<S-CR>'] = 'close_keep_filter',
                j = 'move_cursor_down',
                k = 'move_cursor_up',
              },
            },
          },
        },
        commands = {},
      },
      buffers = {
        follow_current_file = { enabled = true, leave_dirs_open = false },
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
          mappings = {
            ['.'] = 'set_root',
            ['<BS>'] = 'navigate_up',
            bd = 'buffer_delete',
            d = 'buffer_delete',
            o = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            oc = { 'order_by_created', nowait = false },
            od = { 'order_by_diagnostics', nowait = false },
            om = { 'order_by_modified', nowait = false },
            on = { 'order_by_name', nowait = false },
            os = { 'order_by_size', nowait = false },
            ot = { 'order_by_type', nowait = false },
          },
        },
      },
      git_status = {
        window = {
          mappings = {
            A = 'git_add_all',
            gU = 'git_undo_last_commit',
            ga = 'git_add_file',
            gc = 'git_commit',
            gg = 'git_commit_and_push',
            gp = 'git_push',
            gr = 'git_revert_file',
            gu = 'git_unstage_file',
            o = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            oc = { 'order_by_created', nowait = false },
            od = { 'order_by_diagnostics', nowait = false },
            om = { 'order_by_modified', nowait = false },
            on = { 'order_by_name', nowait = false },
            os = { 'order_by_size', nowait = false },
            ot = { 'order_by_type', nowait = false },
          },
          position = 'float',
        },
      },
    })

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = {
        ['<leader>ft'] = { group = '+NeoTree' },
        ['<leader>ftd'] = {
          function()
            vim.cmd.Neotree('close')
          end,
          desc('Close Neo Tree'),
        },
        ['<leader>ftb'] = {
          function()
            vim.cmd.Neotree({ args = { 'buffers', 'toggle' } })
          end,
          desc('Neo Tree Open Buffers'),
        },
        ['<leader>ftf'] = {
          function()
            vim.cmd.Neotree('focus')
          end,
          desc('Focus Neo Tree'),
        },
        ['<leader>fto'] = {
          function()
            vim.cmd.Neotree({ args = { 'filesystem', 'show', 'reveal_force_cwd' } })
          end,
          desc('Show Neo Tree'),
        },
        ['<leader>ftt'] = {
          function()
            vim.cmd.Neotree({ args = { 'filesystem', 'toggle', 'reveal_force_cwd' } })
          end,
          desc('Toggle Neo Tree'),
        },
        ['<leader>ft<Up>'] = {
          function()
            vim.cmd.Neotree({ args = { 'filesystem', 'top', 'reveal_force_cwd' } })
          end,
          desc('Open Neo Tree At The Top'),
        },
        ['<leader>ft<Down>'] = {
          function()
            vim.cmd.Neotree({ args = { 'filesystem', 'bottom', 'reveal_force_cwd' } })
          end,
          desc('Open Neo Tree At The Bottom'),
        },
        ['<leader>ft<Left>'] = {
          function()
            vim.cmd.Neotree({ args = { 'filesystem', 'left', 'reveal_force_cwd' } })
          end,
          ':Neotree filesystem left reveal_force_cwd<CR>',
          desc('Open Neo Tree To The Left'),
        },
        ['<leader>ft<Right>'] = {
          function()
            vim.cmd.Neotree({ args = { 'filesystem', 'right', 'reveal_force_cwd' } })
          end,
          desc('Open Neo Tree To The Right'),
        },
        ['<leader>ftF'] = {
          function()
            vim.cmd.Neotree({ args = { 'filesystem', 'float', 'reveal_force_cwd' } })
          end,
          desc('Neo Tree Float'),
        },
      },
    })
    require('user_api').highlight.hl_from_dict({
      NeoTreeDirectoryIcon = { link = 'NvimTreeFolderIcon' },
      NeoTreeDirectoryName = { link = 'NvimTreeFolderName' },
      NeoTreeFileNameOpened = { link = 'NvimTreeOpenedFile' },
      NeoTreeRootName = { link = 'NvimTreeRootFolder' },
      NeoTreeSymbolicLinkTarget = { link = 'NvimTreeSymlink' },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
