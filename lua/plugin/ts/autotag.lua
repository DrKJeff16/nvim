---@module 'lazy'

return { ---@type LazySpec
    'windwp/nvim-ts-autotag',
    config = function()
        require('nvim-ts-autotag').setup({
            opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false },
            per_filetype = {},
        })
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
