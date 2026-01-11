---@module 'lazy'
return { ---@type LazySpec
  'sindrets/diffview.nvim',
  cmd = {
    'DiffviewToggleFiles',
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewFileHistory',
    'DiffviewFocusFiles',
    'DiffviewLog',
    'DiffviewRefresh',
  },
  version = false,
  cond = require('user_api.check.exists').executable('git'),
  opts = {},
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
