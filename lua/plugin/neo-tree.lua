---@module 'lazy'

return { ---@type LazySpec
    'nvim-neo-tree/neo-tree.nvim',
    lazy = false,
    version = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        'nvim-tree/nvim-web-devicons',
        'saifulapm/neotree-file-nesting-config',
        {
            'antosha417/nvim-lsp-file-operations',
            config = function()
                require('lsp-file-operations').setup()
            end,
        },
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
    config = function()
        require('neo-tree').setup({
            nesting_rules = require('neotree-file-nesting-config').nesting_rules,
            hide_root_node = true,
            retain_hidden_root_indent = true,
            close_if_last_window = false,
            popup_border_style = '',
            enable_git_status = true,
            enable_diagnostics = true,
            open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
            open_files_using_relative_paths = false,
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
                auto_preview = {
                    enabled = true,
                    preview_config = { float = true },
                    event = 'neo_tree_window_after_open',
                },
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
                show_unloaded = true,
                refresh = { delay = 500, event = 'vim_diagnostic_changed', max_items = 10000 },
            },
            default_component_configs = {
                container = { enable_character_fade = true },
                indent = {
                    with_expanders = true,
                    expander_collapsed = '',
                    expander_expanded = '',
                    indent_size = 2,
                    padding = 1,
                    with_markers = true,
                    indent_marker = '│',
                    last_indent_marker = '└',
                    highlight = 'NeoTreeIndentMarker',
                    expander_highlight = 'NeoTreeExpander',
                },
                icon = { ---@diagnostic disable-line:missing-fields
                    folder_closed = '',
                    folder_open = '',
                    folder_empty = '󰜌',
                    folder_empty_open = '',
                    default = '*',
                    highlight = 'NeoTreeFileIcon',
                    ---@param icon table
                    ---@param node table
                    provider = function(icon, node, _)
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
                last_modified = { enabled = false, width = 20, required_width = 88 }, ---@diagnostic disable-line:missing-fields
                created = { enabled = false, width = 20, required_width = 110 }, ---@diagnostic disable-line:missing-fields
                symlink_target = { enabled = true },
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
                    visible = false,
                    show_hidden_count = false,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = false,
                    hide_by_name = { 'node_modules' },
                    hide_by_pattern = {},
                    always_show = {},
                    always_show_by_pattern = {},
                    never_show = { '.DS_Store', 'thumbs.db' },
                    never_show_by_pattern = {},
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
                        ---@type 'fuzzy_sorter_directory'|'fuzzy_finder_directory'
                        D = 'fuzzy_finder_directory',
                        ['#'] = 'fuzzy_sorter',
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
                    fuzzy_finder_mappings = {
                        ['<Down>'] = 'move_cursor_down',
                        ['<C-n>'] = 'move_cursor_down',
                        ['<Up>'] = 'move_cursor_up',
                        ['<C-p>'] = 'move_cursor_up',
                        ['<Esc>'] = 'close',
                        ['<S-CR>'] = 'close_keep_filter',
                        ['<C-CR>'] = 'close_clear_filter',
                        ['<C-w>'] = { '<C-S-w>', raw = true },
                        {
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
        })

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
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
