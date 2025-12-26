---@module 'lazy'

return { ---@type LazySpec
  'windwp/nvim-ts-autotag',
  config = function()
    require('nvim-ts-autotag').setup({
      opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false },
      per_filetype = {},
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
