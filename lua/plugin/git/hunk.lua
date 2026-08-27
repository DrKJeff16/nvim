---@module 'lazy'
return { ---@type LazySpec
  'julienvincent/hunk.nvim',
  dev = true,
  version = false,
  cmd = 'DiffEditor',
  config = function()
    require('hunk').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
