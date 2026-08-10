---@module 'lazy'
return { ---@type LazySpec
  'goolord/alpha-nvim',
  priority = 1000,
  version = false,
  dependencies = { 'nvim-mini/mini.icons' },
  config = function()
    local Theta = require('alpha.themes.theta')
    Theta.header = {
      opts = { hl = 'Type', position = 'center', wrap = 'overflow' },
      type = 'text',
      val = {
        [[      _            _ ]],
        [[     | |_ ____   _(_)_ __ ___  ]],
        [[  _  | |  _ \ \ / / |  _   _ \  ]],
        [[ | | | | | | | V /| | | | | | | ]],
        [[  \___/|_| |_|\_/ |_|_| |_| |_| ]],
      },
    }
    Theta.config.layout[2] = Theta.header
    Theta.file_icons.provider = 'mini'

    require('alpha').setup(Theta.config)
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
