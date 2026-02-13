---@module 'lazy'
return { ---@type LazySpec
  'YouSame2/inlinediff-nvim',
  version = false,
  cmd = 'InlineDiff',
  config = function()
    local IDiff = require('inlinediff')
    IDiff.setup({
      debounce_time = 200,
      ignored_buftype = { 'terminal', 'nofile' },
      ignored_filetype = { 'TelescopePrompt', 'NvimTree', 'neo-tree' },
      colors = {
        InlineDiffAddContext = '#182400',
        InlineDiffAddChange = '#395200',
        InlineDiffDeleteContext = '#240004',
        InlineDiffDeleteChange = '#520005',
      },
    })

    local desc = require('user_api.maps').desc
    require('user_api.config.keymaps').set({
      n = { ['<leader>gd'] = { IDiff.toggle, desc('Toggle Inline Diff') } },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
