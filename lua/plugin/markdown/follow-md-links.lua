---@module 'lazy'
return { ---@type LazySpec
  'jghauser/follow-md-links.nvim',
  dev = true,
  version = false,
  ft = 'markdown',
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('follow-md-links', { clear = true }),
      pattern = 'markdown',
      callback = function(ev)
        local desc = require('user_api').maps.desc
        require('user_api').config.keymaps.set({
          n = { ['<BS>'] = { ':edit #<CR>', desc('Follow Previous File', { buf = ev.buf }) } },
        }, ev.buf)
      end,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
