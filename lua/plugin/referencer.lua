---@module 'lazy'

return { ---@type LazySpec
    'romus204/referencer.nvim',
    version = false,
    cond = false,
    config = function()
        require('referencer').setup()
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
