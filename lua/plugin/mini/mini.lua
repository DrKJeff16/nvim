---@module 'lazy'

return { ---@type LazySpec
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
        require('user_api.config').keymaps({ n = { ['<leader>m'] = { group = '+Mini' } } })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
