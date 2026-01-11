---@module 'lazy'
return { ---@type LazySpec
  'HiPhish/rainbow-delimiters.nvim',
  version = false,
  cond = not require('user_api.check').in_console(),
  config = function()
    require('rainbow-delimiters.setup').setup({
      strategy = {
        [''] = 'rainbow-delimiters.strategy.global',
        bash = 'rainbow-delimiters.strategy.local',
        c = 'rainbow-delimiters.strategy.global',
        commonlisp = 'rainbow-delimiters.strategy.local',
        cpp = 'rainbow-delimiters.strategy.global',
        lua = 'rainbow-delimiters.strategy.local',
        python = 'rainbow-delimiters.strategy.local',
        vim = 'rainbow-delimiters.strategy.local',
      },
      query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
        python = 'rainbow-blocks',
      },
      priority = { [''] = 110, lua = 210 },
      highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
