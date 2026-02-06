---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.starter',
  priority = 1000,
  version = false,
  config = function()
    local MS = require('mini.starter')
    MS.setup({
      autoopen = true,
      header = nil,
      footer = nil,
      query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
      silent = false,
      evaluate_single = true,
      items = {
        {
          { name = 'Projects', action = 'Project', section = 'Projects' },
          { name = 'Recent Projects', action = 'ProjectRecents', section = 'Projects' },
        },
        MS.sections.telescope(),
      },
      content_hooks = {
        MS.gen_hook.adding_bullet(),
        MS.gen_hook.aligning('center', 'center'),
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
