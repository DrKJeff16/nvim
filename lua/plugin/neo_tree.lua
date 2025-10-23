---@module 'lazy'

---@type LazySpec
return {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = false,
    version = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
        'saifulapm/neotree-file-nesting-config',
        { 'mrbjarksen/neo-tree-diagnostics.nvim', main = 'neo-tree.sources.diagnostics' },
        {
            's1n7ax/nvim-window-picker',
            version = false,
            config = function()
                require('window-picker').setup({
                    filter_rules = {
                        include_current_win = false,
                        autoselect_one = true,
                        bo = {
                            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                            buftype = { 'terminal', 'quickfix', 'help' },
                        },
                    },
                })
            end,
        },
    },
    opts = {
        hide_root_node = true,
        retain_hidden_root_indent = true,
        close_if_last_window = false,
        popup_border_style = '',
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
        open_files_using_relative_paths = false,
        sort_case_insensitive = false,
        sort_function = function(a, b)
            if a.type == b.type then
                return a.path > b.path
            end
            return a.type > b.type
        end,
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
                    if state.current_position == 'left' or state.current_position == 'right' then
                        vim.api.nvim_win_call(state.winid, function()
                            local str = require('neo-tree.ui.selector').get()
                            if str then
                                _G.__cached_neo_tree_selector = str
                            end
                        end)
                    end
                end,
            },
            {
                event = 'neo_tree_window_after_open',
                handler = function(args)
                    if args.position == 'left' or args.position == 'right' then
                        vim.cmd.wincmd('=')
                    end
                end,
            },
            {
                event = 'neo_tree_window_after_close',
                handler = function(args)
                    if args.position == 'left' or args.position == 'right' then
                        vim.cmd.wincmd('=')
                    end
                end,
            },
        },

        diagnostics = {
            auto_preview = { -- May also be set to `true` or `false`
                enabled = true, -- Whether to automatically enable preview mode
                preview_config = { float = true }, -- Config table to pass to auto preview (for example `{ use_float = true }`)
                -- event = 'neo_tree_buffer_enter',
                event = 'neo_tree_window_after_open', -- The event to enable auto preview upon (for example `"neo_tree_window_after_open"`)
            },
            bind_to_cwd = true,
            diag_sort_function = 'severity',
            follow_current_file = { -- May also be set to `true` or `false`
                enabled = true, -- This will find and focus the file in the active buffer every time
                always_focus_file = true, -- Focus the followed file, even when focus is currently on a diagnostic item belonging to that file
                expand_followed = true, -- Ensure the node of the followed file is expanded
                leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                leave_files_open = false, -- `false` closes auto expanded files, such as with `:Neotree reveal`
            },
            group_dirs_and_files = true, -- when true, empty folders and files will be grouped together
            group_empty_dirs = true, -- when true, empty directories will be grouped together
            show_unloaded = true, -- show diagnostics from unloaded buffers
            refresh = {
                delay = 500,
                event = 'vim_diagnostic_changed', -- Event to use for updating diagnostics (for example `"neo_tree_buffer_enter"`)
                max_items = 10000, -- The maximum number of diagnostic items to attempt processing
            },
        },
        default_component_configs = {
            container = { enable_character_fade = true },
            indent = {
                with_expanders = true,
                expander_collapsed = '',
                expander_expanded = '',
                indent_size = 2,
                padding = 1, -- extra padding on left hand side
                with_markers = true,
                indent_marker = '│',
                last_indent_marker = '└',
                highlight = 'NeoTreeIndentMarker',
                expander_highlight = 'NeoTreeExpander',
            },
            icon = {
                folder_closed = '',
                folder_open = '',
                folder_empty = '󰜌',
                folder_empty_open = '',
                default = '*',
                highlight = 'NeoTreeFileIcon',
                ---@param icon table
                ---@param node table
                provider = function(icon, node, _) -- default icon provider utilizes nvim-web-devicons if available
                    if node.type == 'file' or node.type == 'terminal' then
                        local web_devicons = require('nvim-web-devicons')
                        local name = node.type == 'terminal' and 'terminal' or node.name
                        local devicon, hl = web_devicons.get_icon(name)
                        icon.text = devicon or icon.text
                        icon.highlight = hl or icon.highlight
                    end
                end,
            },
            diagnostics = {
                symbols = { hint = 'H', info = 'I', warn = '!', error = 'X' },
                highlights = {
                    hint = 'DiagnosticSignHint',
                    info = 'DiagnosticSignInfo',
                    warn = 'DiagnosticSignWarn',
                    error = 'DiagnosticSignError',
                },
            },
            modified = { symbol = '[+]', highlight = 'NeoTreeModified' },
            name = {
                trailing_slash = true,
                use_git_status_colors = true,
                highlight = 'NeoTreeFileName',
            },
            git_status = {
                symbols = {
                    added = '✚',
                    modified = '',
                    deleted = '✖',
                    renamed = '󰁕',
                    untracked = '',
                    ignored = '',
                    unstaged = '󰄱',
                    staged = '',
                    conflict = '',
                },
            },
            file_size = { enabled = false, width = 12, required_width = 64 },
            type = { enabled = true, width = 10, required_width = 122 },
            last_modified = { ---@diagnostic disable-line:missing-fields
                enabled = false,
                width = 20,
                required_width = 88,
            },
            created = { ---@diagnostic disable-line:missing-fields
                enabled = false,
                width = 20,
                required_width = 110,
            },
            symlink_target = { enabled = true },
        },
        commands = {}, -- see `:h neo-tree-custom-commands-global`
        window = {
            position = 'left',
            width = 40,
            mapping_options = { noremap = true, nowait = true },
            mappings = {
                ['<Tab>'] = function(state)
                    state.commands['open'](state)
                    vim.cmd.Neotree('reveal')
                end,
                ['<CR>'] = 'open',
                ['<Esc>'] = 'cancel',
                P = {
                    'toggle_preview',
                    config = {
                        use_float = true,
                        use_snacks_image = false,
                        use_image_nvim = false,
                    },
                },
                l = 'focus_preview',
                S = 'open_split',
                s = 'open_vsplit',
                t = 'open_tabnew',
                w = 'open_with_window_picker',
                C = 'close_node',
                z = 'close_all_nodes',
                Z = 'expand_all_subnodes',
                a = {
                    'add',
                    -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                    -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                    config = {
                        show_path = 'absolute', -- "none", "relative", "absolute"
                    },
                },
                A = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                d = 'delete',
                r = 'rename',
                b = 'rename_basename',
                y = 'copy_to_clipboard',
                x = 'cut_to_clipboard',
                p = 'paste_from_clipboard',
                -- c = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
                c = {
                    'copy',
                    config = {
                        show_path = 'absolute', -- "none", "relative", "absolute"
                    },
                },
                m = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
                q = 'close_window',
                R = 'refresh',
                ['?'] = 'show_help',
                ['<'] = 'prev_source',
                ['>'] = 'next_source',
                i = {
                    'show_file_details',
                    -- format strings of the timestamps shown for date created and last modified (see `:h os.date()`)
                    -- both options accept a string or a function that takes in the date in seconds and returns a string to display
                    config = {
                        created_format = '%Y-%m-%d %I:%M %p',
                        modified_format = function(seconds)
                            return require('neo-tree.utils').relative_date(seconds)
                        end,
                    },
                },
            },
        },
        filesystem = {
            filtered_items = {
                visible = false,
                show_hidden_count = false,
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = false,
                hide_by_name = { 'node_modules' },
                hide_by_pattern = { -- uses glob style patterns
                    --"*.meta",
                    --"*/src/*/tsconfig.json",
                },
                always_show = { -- remains visible even if other settings would normally hide it
                    --".gitignored",
                },
                always_show_by_pattern = { -- uses glob style patterns
                    --".env*",
                },
                never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                    '.DS_Store',
                    'thumbs.db',
                },
                never_show_by_pattern = { -- uses glob style patterns
                    --".null-ls_*",
                },
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
                    -- D = 'fuzzy_finder_directory',
                    D = 'fuzzy_sorter_directory',
                    ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
                    f = 'filter_on_submit',
                    ['<c-x>'] = 'clear_filter',
                    ['[g'] = 'prev_git_modified',
                    [']g'] = 'next_git_modified',
                    o = {
                        'show_help',
                        nowait = false,
                        config = { title = 'Order by', prefix_key = 'o' },
                    },
                    oc = { 'order_by_created', nowait = false },
                    od = { 'order_by_diagnostics', nowait = false },
                    og = { 'order_by_git_status', nowait = false },
                    om = { 'order_by_modified', nowait = false },
                    on = { 'order_by_name', nowait = false },
                    os = { 'order_by_size', nowait = false },
                    ot = { 'order_by_type', nowait = false },
                },
                fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
                    ['<Down>'] = 'move_cursor_down',
                    ['<C-n>'] = 'move_cursor_down',
                    ['<Up>'] = 'move_cursor_up',
                    ['<C-p>'] = 'move_cursor_up',
                    ['<Esc>'] = 'close',
                    ['<S-CR>'] = 'close_keep_filter',
                    ['<C-CR>'] = 'close_clear_filter',
                    ['<C-w>'] = { '<C-S-w>', raw = true },
                    {
                        -- normal mode mappings
                        n = {
                            j = 'move_cursor_down',
                            k = 'move_cursor_up',
                            ['<S-CR>'] = 'close_keep_filter',
                            ['<C-CR>'] = 'close_clear_filter',
                            ['<Esc>'] = 'close',
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
                    d = 'buffer_delete',
                    bd = 'buffer_delete',
                    ['<BS>'] = 'navigate_up',
                    ['.'] = 'set_root',
                    o = {
                        'show_help',
                        nowait = false,
                        config = { title = 'Order by', prefix_key = 'o' },
                    },
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
                position = 'float',
                mappings = {
                    A = 'git_add_all',
                    gu = 'git_unstage_file',
                    gU = 'git_undo_last_commit',
                    ga = 'git_add_file',
                    gr = 'git_revert_file',
                    gc = 'git_commit',
                    gp = 'git_push',
                    gg = 'git_commit_and_push',
                    o = {
                        'show_help',
                        nowait = false,
                        config = { title = 'Order by', prefix_key = 'o' },
                    },
                    oc = { 'order_by_created', nowait = false },
                    od = { 'order_by_diagnostics', nowait = false },
                    om = { 'order_by_modified', nowait = false },
                    on = { 'order_by_name', nowait = false },
                    os = { 'order_by_size', nowait = false },
                    ot = { 'order_by_type', nowait = false },
                },
            },
        },
    },
    config = function(_, opts)
        opts.nesting_rules = require('neotree-file-nesting-config').nesting_rules
        require('neo-tree').setup(opts)

        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = {
                ['<leader>ft'] = { group = '+NeoTree' },
                ['<leader>ftd'] = { ':Neotree close<CR>', desc('Close Neo Tree') },
                ['<leader>ftb'] = { ':Neotree buffers toggle<CR>', desc('Neo Tree Open Buffers') },
                ['<leader>ftf'] = { ':Neotree focus<CR>', desc('Focus Neo Tree') },
                ['<leader>fto'] = {
                    ':Neotree filesystem show reveal_force_cwd<CR>',
                    desc('Show Neo Tree'),
                },
                ['<leader>ftt'] = {
                    ':Neotree filesystem toggle reveal_force_cwd<CR>',
                    desc('Toggle Neo Tree'),
                },
                ['<leader>ft<Up>'] = {
                    ':Neotree filesystem top reveal_force_cwd<CR>',
                    desc('Open Neo Tree At The Top'),
                },
                ['<leader>ft<Down>'] = {
                    ':Neotree filesystem bottom reveal_force_cwd<CR>',
                    desc('Open Neo Tree At The Bottom'),
                },
                ['<leader>ft<Left>'] = {
                    ':Neotree filesystem left reveal_force_cwd<CR>',
                    desc('Open Neo Tree To The Left'),
                },
                ['<leader>ft<Right>'] = {
                    ':Neotree filesystem right reveal_force_cwd<CR>',
                    desc('Open Neo Tree To The Right'),
                },
                ['<leader>ftF'] = {
                    ':Neotree filesystem float reveal_force_cwd<CR>',
                    desc('Neo Tree Float'),
                },
            },
        })
        vim.cmd([[
            hi! link NeoTreeDirectoryIcon NvimTreeFolderIcon
            hi! link NeoTreeDirectoryName NvimTreeFolderName
            hi! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
            hi! link NeoTreeRootName NvimTreeRootFolder
            hi! link NeoTreeDirectoryName NvimTreeOpenedFolderName
            hi! link NeoTreeFileNameOpened NvimTreeOpenedFile
        ]])
    end,
}
