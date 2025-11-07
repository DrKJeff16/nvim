---@module 'lazy'

---@type LazySpec
return {
    'klen/nvim-test',
    lazy = true,
    version = false,
    cmd = {
        'TestEdit',
        'TestFile',
        'TestInfo',
        'TestLast',
        'TestNearest',
        'TestSuite',
        'TestVisit',
    },
    config = function()
        require('nvim-test').setup({
            run = true,
            commands_create = true,
            filename_modifier = ':.',
            silent = false,
            term = 'terminal',
            termOpts = {
                direction = 'vertical',
                width = 96,
                height = 24,
                go_back = false,
                stopinsert = 'auto',
                keep_one = true,
            },
            runners = {
                cs = 'nvim-test.runners.dotnet',
                go = 'nvim-test.runners.go-test',
                haskell = 'nvim-test.runners.hspec',
                javascriptreact = 'nvim-test.runners.jest',
                javascript = 'nvim-test.runners.jest',
                lua = 'nvim-test.runners.busted',
                python = 'nvim-test.runners.pytest',
                ruby = 'nvim-test.runners.rspec',
                rust = 'nvim-test.runners.cargo-test',
                typescript = 'nvim-test.runners.jest',
                typescriptreact = 'nvim-test.runners.jest',
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
