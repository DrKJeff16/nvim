---@module 'lazy'

return { ---@type LazySpec
    'goolord/alpha-nvim',
    priority = 1000,
    version = false,
    dependencies = { 'nvim-mini/mini.icons' },
    config = function()
        local Theta = require('alpha.themes.theta')
        Theta.header = {
            type = 'text',
            val = {
                [[      _            _ ]],
                [[     | |_ ____   _(_)_ __ ___  ]],
                [[  _  | |  _ \ \ / / |  _   _ \  ]],
                [[ | | | | | | | V /| | | | | | | ]],
                [[  \___/|_| |_|\_/ |_|_| |_| |_| ]],
            },
            opts = { position = 'center', hl = 'Type', wrap = 'overflow' },
        }
        Theta.config.layout[2] = Theta.header
        Theta.file_icons.provider = 'mini'

        require('alpha').setup(Theta.config)
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
