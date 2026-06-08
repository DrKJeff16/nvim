---@module 'lazy'
return { ---@type LazySpec
  'folke/drop.nvim',
  version = false,
  config = function()
    require('drop').setup({
      theme = 'auto', ---@type DropTheme|string
      themes = { ---@type ({ theme: string }|DropDate|{ from: DropDate, to: DropDate }|{ holiday: "us_thanksgiving"|"easter" })[]
        { theme = 'new_year', month = 1, day = 1 },
        { theme = 'valentines_day', month = 2, day = 14 },
        { theme = 'april_fools', month = 4, day = 1 },
        { theme = 'us_independence_day', month = 7, day = 4 },
        { theme = 'halloween', month = 10, day = 31 },
        { theme = 'xmas', from = { month = 12, day = 24 }, to = { month = 12, day = 25 } },
        { theme = 'leaves', from = { month = 9, day = 22 }, to = { month = 12, day = 20 } },
        { theme = 'snow', from = { month = 12, day = 21 }, to = { month = 3, day = 19 } },
        { theme = 'spring', from = { month = 3, day = 20 }, to = { month = 6, day = 20 } },
        { theme = 'summer', from = { month = 6, day = 21 }, to = { month = 9, day = 21 } },
      },
      max = 150,
      interval = 70,
      screensaver = 1000 * 60 * 5,
      filetypes = { 'dashboard', 'alpha', 'ministarter' },
      winblend = 100,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
