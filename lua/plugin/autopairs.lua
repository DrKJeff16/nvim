---@module 'lazy'

return { ---@type LazySpec
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    version = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'RRethy/nvim-treesitter-endwise' },
    config = function()
        require('nvim-autopairs').setup({
            enabled = function(bufnr) ---@param bufnr integer
                local EXCEPT_FT = {
                    'TelescopePrompt',
                    'TelescopeResults',
                    'lazy',
                    'man',
                    'minimap',
                    'notify',
                    'packer',
                    'qf',
                    'snacks_picker_input',
                    'spectre_panel',
                }
                local EXCEPT_BT = { 'help', 'nofile', 'nowrite', 'prompt', 'quickfix', 'terminal' }
                local ft = require('user_api.util').ft_get(bufnr)
                local bt = require('user_api.util').bt_get(bufnr)
                local in_list = vim.list_contains
                return not (in_list(EXCEPT_FT, ft) or in_list(EXCEPT_BT, bt))
            end,
            disable_filetype = { 'TelescopePrompt', 'snacks_picker_input', 'spectre_panel' },
            disable_in_macro = true,
            disable_in_visualblock = false,
            disable_in_replace_mode = true,
            ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
            enable_moveright = true,
            enable_afterquote = true,
            enable_check_bracket_line = false,
            enable_bracket_in_quote = true,
            enable_abbr = false,
            break_undo = true,
            check_ts = true,
            ts_config = { lua = { 'string' } },
            map_cr = true,
            map_bs = false,
            map_c_h = false,
            map_c_w = false,
        })

        local joined_bracks = { '()', '[]', '{}' }
        local spaced_bracks = { '(  )', '[  ]', '{  }' }
        local bracks = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
        local Rule = require('nvim-autopairs.rule')
        local cond = require('nvim-autopairs.conds')
        local ts_node = require('nvim-autopairs.ts-conds').is_ts_node
        local Rules = { ---@type Rule[]
            Rule('$', '$', { 'tex', 'latex' })
                :with_pair(cond.not_after_regex('%%'))
                :with_pair(cond.not_before_regex('xxx', 3))
                :with_move(cond.none())
                :with_del(cond.not_after_regex('xx'))
                :with_cr(cond.none()),

            Rule('$$', '$$', { 'tex', 'latex' }):with_pair(function(opts)
                if opts.line == 'aa $$' then
                    return false
                end
            end),

            Rule(' ', ' ')
                :with_pair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.list_contains(joined_bracks, pair)
                end)
                :with_move(cond.none())
                :with_cr(cond.none())
                :with_del(function(opts)
                    local col = vim.api.nvim_win_get_cursor(0)[2]
                    local context = opts.line:sub(col - 1, col + 2)
                    return vim.list_contains(spaced_bracks, context)
                end),

            Rule('<', '>', { '-html', '-markdown', '-javascriptreact', '-typescriptreact' })
                :with_pair(cond.before_regex('%a+:?:?$', 3))
                :with_move(function(opts)
                    return opts.char == '>'
                end),

            Rule('{', '},', 'lua'):with_pair(ts_node({ 'table_constructor' })),
            Rule("'", "',", 'lua'):with_pair(ts_node({ 'table_constructor' })),
            Rule('"', '",', 'lua'):with_pair(ts_node({ 'table_constructor' })),
        }
        for _, bracket in ipairs(bracks) do
            table.insert(
                Rules,
                Rule(bracket[1] .. ' ', ' ' .. bracket[2])
                    :with_pair(cond.none())
                    :with_move(function(opts)
                        return opts.char == bracket[2]
                    end)
                    :with_del(cond.none())
                    :use_key(bracket[2])
                    :replace_map_cr(function(_)
                        return '<C-c>2xi<CR><C-c>O'
                    end)
            )
        end
        for _, punct in ipairs({ ',', ';' }) do
            table.insert(
                Rules,
                Rule('', punct)
                    :with_move(function(opts)
                        return opts.char == punct
                    end)
                    :with_pair(function()
                        return false
                    end)
                    :with_del(function()
                        return false
                    end)
                    :with_cr(function()
                        return false
                    end)
                    :use_key(punct)
            )
        end
        require('nvim-autopairs').add_rules(Rules)
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
