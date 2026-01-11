---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.nvim',
  version = false,
  config = function()
    require('user_api.config').keymaps({ n = { ['<leader>m'] = { group = '+Mini' } } })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
