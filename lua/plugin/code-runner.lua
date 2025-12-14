---@module 'lazy'

return { ---@type LazySpec
    'wsdjeg/code-runner.nvim',
    version = false,
    dependencies = { 'wsdjeg/job.nvim', 'wsdjeg/notify.nvim' },
    config = function()
        require('code-runner').setup({
            runners = { lua = { exe = 'lua', opt = { '-' }, usestdin = true } },
            enter_win = false,
        })
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
