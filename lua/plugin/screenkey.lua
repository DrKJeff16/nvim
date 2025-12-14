---@module 'lazy'

return { ---@type LazySpec
    'NStefan002/screenkey.nvim',
    dev = true,
    lazy = false,
    version = false,
    cond = not require('user_api.check').in_console(),
    config = function()
        require('screenkey').setup({
            win_opts = {
                row = 0,
                col = math.floor((vim.o.columns - 60) / 2) - 1,
                relative = 'editor',
                anchor = 'NW',
                width = 60,
                height = 3,
                border = 'rounded',
                title = {
                    { 'Sc', 'DiagnosticOk' },
                    { 're', 'DiagnosticWarn' },
                    { 'en', 'DiagnosticInfo' },
                    { 'key', 'DiagnosticError' },
                },
                title_pos = 'center',
                style = 'minimal',
                focusable = false,
                noautocmd = true,
                zindex = 50,
            },
            hl_groups = {
                ['screenkey.hl.key'] = { link = 'DiagnosticOk' },
                ['screenkey.hl.map'] = { link = 'DiagnosticWarn' },
                ['screenkey.hl.sep'] = { bg = 'red', fg = 'blue' },
            },
            compress_after = 2,
            clear_after = 3,
            emit_events = true,
            disable = {
                filetypes = {},
                buftypes = { 'terminal' },
                modes = { 'i' },
            },
            show_leader = true,
            group_mappings = true,
            display_infront = {},
            display_behind = {},
            filter = function(keys)
                for i, k in ipairs(keys) do
                    if require('screenkey').statusline_component_is_active() and k.key == '%' then
                        keys[i].key = '%%'
                    end
                end
                return keys
            end,
            separator = ' ',
            keys = {
                ['<TAB>'] = '󰌒',
                ['<CR>'] = '󰌑',
                ['<ESC>'] = 'Esc',
                ['<SPACE>'] = '␣',
                ['<BS>'] = '󰌥',
                ['<DEL>'] = 'Del',
                ['<LEFT>'] = '',
                ['<RIGHT>'] = '',
                ['<UP>'] = '',
                ['<DOWN>'] = '',
                ['<HOME>'] = 'Home',
                ['<END>'] = 'End',
                ['<PAGEUP>'] = 'PgUp',
                ['<PAGEDOWN>'] = 'PgDn',
                ['<INSERT>'] = 'Ins',
                ['<F1>'] = '󱊫',
                ['<F2>'] = '󱊬',
                ['<F3>'] = '󱊭',
                ['<F4>'] = '󱊮',
                ['<F5>'] = '󱊯',
                ['<F6>'] = '󱊰',
                ['<F7>'] = '󱊱',
                ['<F8>'] = '󱊲',
                ['<F9>'] = '󱊳',
                ['<F10>'] = '󱊴',
                ['<F11>'] = '󱊵',
                ['<F12>'] = '󱊶',
                ['CTRL'] = 'Ctrl',
                ['ALT'] = 'Alt',
                ['SUPER'] = 'Super',
                ['<leader>'] = '<leader>',
            },
            notify_method = 'notify',
            log = {
                min_level = vim.log.levels.OFF,
                filepath = vim.fn.stdpath('state') .. '/screenkey.log',
            },
        })

        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = { ['<leader><C-s>'] = { require('screenkey').toggle, desc('Toggle Screenkey') } },
        })
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
