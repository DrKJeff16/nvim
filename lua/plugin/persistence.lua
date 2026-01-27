---@module 'lazy'
return { ---@type LazySpec
  'folke/persistence.nvim',
  event = 'BufReadPre',
  version = false,
  config = function()
    local Persistence = require('persistence')
    Persistence.setup({
      dir = vim.fn.stdpath('state') .. '/sessions/',
      need = 1,
      branch = true,
    })

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps.set({
      n = {
        ['<leader>s'] = { group = '+Session' },
        ['<leader>ss'] = { Persistence.load, desc('Load Session') },
        ['<leader>sS'] = { Persistence.select, desc('Select Session') },
        ['<leader>sd'] = { Persistence.stop, desc('Stop Session') },
        ['<leader>sl'] = {
          function()
            Persistence.load({ last = true })
          end,
          desc('Load Last Session'),
        },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
