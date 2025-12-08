---@module 'lazy'

return {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
        require('ts_context_commentstring').setup({ enable_autocmd = false })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
