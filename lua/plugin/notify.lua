---@module 'lazy'

local set_hl = vim.schedule_wrap(function()
  require('user_api.highlight').hl_from_dict({
    NotifyDEBUGBody = { link = 'Normal' },
    NotifyDEBUGBorder = { fg = '#CBCB42' },
    NotifyDEBUGIcon = { fg = '#909042' },
    NotifyDEBUGTitle = { fg = '#CBCB42' },
    NotifyERRORBody = { link = 'ErrorMsg' },
    NotifyERRORBorder = { fg = '#8A1F1F' },
    NotifyERRORIcon = { fg = '#F70067' },
    NotifyERRORTitle = { fg = '#F70067' },
    NotifyINFOBody = { link = 'Normal' },
    NotifyINFOBorder = { fg = '#4F6752' },
    NotifyINFOIcon = { fg = '#A9FF68' },
    NotifyINFOTitle = { fg = '#A9FF68' },
    NotifyLOGBody = { link = 'Normal' },
    NotifyLOGBorder = { fg = '#3F6072' },
    NotifyLOGIcon = { fg = '#59BFAB' },
    NotifyLOGTitle = { fg = '#59BFAB' },
    NotifyTRACEBody = { link = 'Normal' },
    NotifyTRACEBorder = { fg = '#4F3552' },
    NotifyTRACEIcon = { fg = '#D484FF' },
    NotifyTRACETitle = { fg = '#D484FF' },
    NotifyWARNBody = { link = 'WarningMsg' },
    NotifyWARNBorder = { fg = '#79491D' },
    NotifyWARNIcon = { fg = '#F79000' },
    NotifyWARNTitle = { fg = '#F79000' },
  })
end)

return { ---@type LazySpec
  'rcarriga/nvim-notify',
  priority = 1000,
  version = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  cond = not require('user_api.check').in_console(),
  config = function()
    require('notify').setup({
      background_colour = 'NotifyBackground',
      merge_duplicates = true,
      fps = 60,
      icons = { DEBUG = '', ERROR = '', INFO = '', TRACE = '✎', WARN = '' },
      level = vim.log.levels.INFO,
      minimum_width = 15,
      render = 'default',
      stages = 'fade_in_slide_out',
      time_formats = { notification = '%T', notification_history = '%FT%T' },
      timeout = 2500,
      top_down = true,
    })
    vim.notify = require('notify')

    if require('user_api.check.exists').module('telescope') then
      require('telescope').load_extension('notify')

      local desc = require('user_api.maps').desc
      require('user_api.config').keymaps({
        n = {
          ['<leader>N'] = { group = '+Notify' },
          ['<leader>NT'] = { ':Telescope notify<CR>', desc('Notify Telescope Picker') },
          ['<leader><C-t>eN'] = { ':Telescope notify<CR>', desc('Notify Picker') },
        },
      })
    end

    set_hl()

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('NotifyHl', { clear = true }),
      callback = function()
        set_hl()
      end,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
