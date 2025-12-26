---@module 'lazy'

return { ---@type LazySpec
  'wsdjeg/scrollbar.vim',
  version = false,
  cond = not require('user_api.check').in_console(),
  config = function()
    require('scrollbar').setup({
      max_size = 10,
      min_size = 5,
      width = 1,
      right_offset = 1,
      shape = { head = '▲', body = '█', tail = '▼' },
      highlight = { head = 'Normal', body = 'Normal', tail = 'Normal' },
      excluded_filetypes = {
        'TelescopePrompt',
        'notify',
        'startify',
        'NvimTree',
        'ministarter',
        'neo-tree',
        'lazy',
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
