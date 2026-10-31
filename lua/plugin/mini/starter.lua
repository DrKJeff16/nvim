---@module 'lazy'
return { ---@type LazySpec
  'nvim-mini/mini.starter',
  priority = 1000,
  version = false,
  config = function()
    local MS = require('mini.starter')
    MS.setup({
      autoopen = true,
      content_hooks = { MS.gen_hook.adding_bullet(), MS.gen_hook.aligning('center', 'center') },
      evaluate_single = true,
      items = {
        {
          { name = 'Dashboard', action = 'Lazy', section = 'lazy.nvim' },
          { name = 'Sync Plugins', action = 'Lazy sync', section = 'lazy.nvim' },
          { name = 'Check Plugins', action = 'Lazy check', section = 'lazy.nvim' },
        },
        {
          { name = 'Menu', action = 'Project', section = 'project.nvim' },
          { name = 'Recents', action = 'Project recents', section = 'project.nvim' },
          { name = 'New', action = 'Project add', section = 'project.nvim' },
          { name = 'History', action = 'Project history', section = 'project.nvim' },
        },
        {
          { name = 'Stats', action = 'Triforce profile stats', section = 'triforce.nvim' },
          { name = 'Achievements', action = 'Triforce profile stats', section = 'triforce.nvim' },
          { name = 'Languages', action = 'Triforce profile languages', section = 'triforce.nvim' },
          { name = 'Levels', action = 'Triforce profile levels', section = 'triforce.nvim' },
        },
        {
          { name = 'General', action = 'checkhealth vim.health', section = 'Health' },
          { name = 'LSP', action = 'checkhealth vim.lsp', section = 'Health' },
          { name = 'Pack', action = 'checkhealth vim.pack', section = 'Health' },
          { name = 'Providers', action = 'checkhealth vim.provider', section = 'Health' },
          { name = 'Treesitter', action = 'checkhealth vim.treesitter', section = 'Health' },
          { name = 'Deprecated', action = 'checkhealth vim.deprecated', section = 'Health' },
        },
      },
      query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
      silent = false,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
