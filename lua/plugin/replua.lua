---@module 'lazy'

return { ---@type LazySpec
    'mghaight/replua.nvim',
    version = false,
    config = function()
        require('replua').setup({
            open_command = 'enew',
            intro_lines = { '-- Scratch buffer for Lua evaluation', '' },
            keymaps = {
                eval_line = '<leader>rl',
                eval_block = '<leader>r<CR>',
                eval_buffer = '<leader>rb',
            },
            print_prefix = '-- print: ',
            result_prefix = '-- => ',
            result_continuation_prefix = '--    ',
            error_prefix = '-- Error: ',
            show_nil_results = true,
            newline_after_result = true,
            persist_env = true,
        })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
