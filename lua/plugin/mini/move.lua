---@module 'lazy'

return { ---@type LazySpec
    'nvim-mini/mini.move',
    version = false,
    config = function()
        local mappings = function()
            if require('user_api.check').in_console() then
                return {
                    left = '<S-Left>',
                    right = '<S-Right>',
                    down = '<S-Down>',
                    up = '<S-Up>',
                    line_left = '<S-Left>',
                    line_right = '<S-Right>',
                    line_down = '<S-Down>',
                    line_up = '<S-Up>',
                }
            end
            return {
                left = '<C-Left>',
                right = '<C-Right>',
                down = '<C-Down>',
                up = '<C-Up>',
                line_left = '<C-Left>',
                line_right = '<C-Right>',
                line_down = '<C-Down>',
                line_up = '<C-Up>',
            }
        end

        require('mini.move').setup({
            mappings = mappings(),
            options = { reindent_linewise = true },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
