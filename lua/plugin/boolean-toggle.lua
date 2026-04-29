---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/boolean-toggle.nvim',
  dev = true,
  version = false,
  config = function()
    require('boolean-toggle').setup({
      custom_spec = {
        { yes = '1', no = '0', ft = { 'c', 'cpp' } },
      },
      keymaps = { toggle = '<CR>' },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
