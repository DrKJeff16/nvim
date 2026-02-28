---@module 'lazy'
return { ---@type LazySpec
  'wsdjeg/record-key.nvim',
  cmd = { 'RecordKeyToggle' },
  config = function()
    require('record-key').setup({
      timeout = 3000,
      max_count = 5,
      winhighlight = 'NormalFloat:Normal,FloatBorder:WinSeparator',
    })

    local desc = require('user_api.maps').desc
    require('user_api.config.keymaps').set({
      n = {
        ['<leader>r'] = { group = '+Record Keys' },
        ['<leader>rk'] = { vim.cmd.RecordKeyToggle, desc('Toggle') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
