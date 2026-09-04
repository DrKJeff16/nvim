---@module 'lazy'
return { ---@type LazySpec
  'Bekaboo/dropbar.nvim',
  version = false,
  event = 'VeryLazy',
  dependencies = { { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' } },
  config = function()
    vim.ui.select = require('dropbar.utils.menu').select

    local dropbar_api = require('dropbar.api')
    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = {
        ['<Leader>;'] = { dropbar_api.pick, desc('Pick symbols in winbar') },
        ['[;'] = { dropbar_api.goto_context_start, desc('Go to start of current context') },
        ['];'] = { dropbar_api.select_next_context, desc('Select next context') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
