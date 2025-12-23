---@module 'lazy'
return { ---@type LazySpec
    'StikyPiston/cheaty.nvim',
    dev = true,
    version = false,
    config = function()
        require('cheaty').setup()
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
