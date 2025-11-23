---@module 'lazy'

return { ---@type LazySpec
    'nvim-mini/mini.splitjoin',
    version = false,
    config = function()
        require('mini.splitjoin').setup({
            mappings = { toggle = '<leader>mst', split = '<leader>mss', join = '<leader>msj' },
            detect = {
                brackets = { '%b()', '%b[]', '%b{}' },
                separator = '[,;]',
                exclude_regions = { '%b()', '%b[]', '%b{}', '%b""', "%b''" },
            },
            split = { hooks_pre = {}, hooks_post = {} },
            join = { hooks_pre = {}, hooks_post = {} },
        })

        require('user_api.config').keymaps({ n = { ['<leader>ms'] = { group = '+Splitjoin' } } })
        vim.api.nvim_create_autocmd({ 'BufNew', 'BufAdd', 'BufEnter', 'BufCreate', 'WinEnter' }, {
            group = vim.api.nvim_create_augroup('UserMini', { clear = false }),
            callback = function(ev)
                local ft = require('user_api.util').ft_get(ev.buf)
                local accepted = { 'lua' }
                if not vim.list_contains(accepted, ft) then
                    return
                end

                local add_trail_sep = require('mini.splitjoin').gen_hook.add_trailing_separator
                local del_trail_sep = require('mini.splitjoin').gen_hook.del_trailing_separator
                local pad_bracks = require('mini.splitjoin').gen_hook.pad_brackets
                local bracks = { brackets = { '%b{}' } }
                local join = { hooks_post = { add_trail_sep(bracks) } }
                local split = { hooks_post = { del_trail_sep(bracks), pad_bracks(bracks) } }
                vim.b.minisplitjoin_config = { split = split, join = join }
            end,
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
