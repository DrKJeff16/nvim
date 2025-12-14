---@module 'lazy'

return { ---@type LazySpec
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    version = false,
    init = require('config.util').flag_installed('startuptime'),
    config = function()
        local opts = {
            colorize = true,
            event_width = 0,
            fine_blocks = vim.fn.has('win32') ~= 1,
            more_info_key_seq = 'K',
            other_events = true,
            plot_width = 30,
            sort = true,
            sourced = true,
            sourcing_events = true,
            split_edit_key_seq = 'gf',
            startup_indent = 8,
            time_width = 8,
            tries = 10,
            use_blocks = vim.o.encoding == 'utf-8',
            zero_progress_msg = true,
            zero_progress_time = 2500,
        }
        for flag, val in pairs(opts) do
            vim.g[('startuptime_%s'):format(flag)] = val
        end

        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = { ['<leader>vS'] = { vim.cmd.StartupTime, desc('Run StartupTime') } },
        })

        require('user_api.highlight').hl_from_dict({
            StartupTimeSourcingEvent = { link = 'Title' },
        })
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
