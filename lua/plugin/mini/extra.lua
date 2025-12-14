---@module 'lazy'

return { ---@type LazySpec
    'nvim-mini/mini.extra',
    version = false,
    config = function()
        require('mini.extra').setup({})
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
