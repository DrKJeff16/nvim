---@module 'lazy'
return { ---@type LazySpec
  'rcarriga/nvim-notify',
  priority = 1000,
  version = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  cond = not require('user_api.check').in_console(),
  config = function()
    local Notify = require('notify')
    Notify.setup({
      background_colour = 'NotifyBackground',
      merge_duplicates = true,
      fps = 144,
      icons = { DEBUG = '', ERROR = '', INFO = '', TRACE = '✎', WARN = '' },
      level = vim.log.levels.INFO,
      minimum_width = 32,
      render = 'simple',
      stages = 'fade_in_slide_out',
      time_formats = { notification = '%T', notification_history = '%FT%T' },
      timeout = 2250,
      top_down = true,
    })
    vim.notify = Notify

    if require('user_api.check').module('telescope') then
      require('telescope').load_extension('notify')

      local desc = require('user_api.maps').desc
      require('user_api.config').keymaps.set({
        n = {
          ['<leader>N'] = { group = '+Notify' },
          ['<leader>NT'] = { ':Telescope notify<CR>', desc('Notify Telescope Picker') },
          ['<leader><C-t>eN'] = { ':Telescope notify<CR>', desc('Notify Picker') },
        },
      })
    end
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
