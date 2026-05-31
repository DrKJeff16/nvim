---@module 'lazy'
return { ---@type LazySpec
  'Crysthamus/nvim-file-operations',
  config = function()
    require('nvim-file-operations').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
