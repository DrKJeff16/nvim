---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.starter',
    version = false,
    config = function()
        require('mini.starter').setup({
            autoopen = true,
            header = nil,
            footer = nil,
            query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
            silent = false,
            evaluate_single = true,
            items = {
                { name = 'Projects', action = 'Project', section = 'Projects' },
                { name = 'Recent Projects', action = 'ProjectRecents', section = 'Projects' },
                require('mini.starter').sections.telescope(),
            },
            content_hooks = {
                require('mini.starter').gen_hook.adding_bullet(),
                require('mini.starter').gen_hook.aligning('center', 'center'),
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
