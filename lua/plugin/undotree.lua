---@module 'lazy'

return { ---@type LazySpec
    'jiaoshijie/undotree',
    version = false,
    dependencies = { 'nvim-lua/plenary.nvim' },
    enabled = false,
    config = function()
        require('undotree').setup({
            float_diff = true,
            layout = 'left_bottom',
            position = 'left',
            ignore_filetype = {
                'TelescopePrompt',
                'help',
                'lazy',
                'notify',
                'qf',
                'spectre_panel',
                'tsplayground',
                'undotree',
                'undotreeDiff',
            },
            window = { winblend = 10 },
            keymaps = {
                J = 'move_change_next',
                K = 'move_change_prev',
                ['<cr>'] = 'action_enter',
                gj = 'move2parent',
                j = 'move_next',
                k = 'move_prev',
                p = 'enter_diffbuf',
                q = 'quit',
            },
        })

        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = { ['<leader><M-u>'] = { require('undotree').toggle, desc('Toggle UndoTree') } },
        })

        vim.api.nvim_create_user_command('Undotree', function(ctx)
            if vim.tbl_isempty(ctx.fargs) then
                require('undotree').toggle()
                return
            end
            local cmd = ctx.fargs[1]
            if cmd == 'toggle' then
                require('undotree').toggle()
                return
            end
            if cmd == 'open' then
                require('undotree').open()
                return
            end
            if cmd == 'close' then
                require('undotree').close()
                return
            end

            vim.notify(('Invalid subcommand: `%s`'):format(cmd or ''), vim.log.levels.ERROR)
        end, {
            nargs = '?',
            desc = 'Undotree command with subcommands: toggle, open, close',
            complete = function(_, line)
                local input = vim.split(line, '%s+')
                local prefix = input[#input]
                return vim.tbl_filter(function(cmd)
                    return vim.startswith(cmd, prefix)
                end, { 'toggle', 'open', 'close' })
            end,
        })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
