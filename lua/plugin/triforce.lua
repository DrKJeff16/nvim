---@module 'lazy'
return { ---@type LazySpec
  'gisketch/triforce.nvim',
  dev = true,
  version = false,
  event = 'VeryLazy',
  dependencies = { { 'nvzone/volt', dev = true } },
  config = function()
    require('triforce').setup({
      achievements = {
        {
          check = function(stats)
            return stats.sessions >= 1
          end,
          desc = 'Open up your first session',
          icon = '✨',
          id = 'first_session',
          name = 'Starter',
        },
        {
          check = function(stats)
            return stats.chars_typed >= 300
          end,
          desc = 'Type 300 Characters',
          icon = '✨',
          id = 'first_300',
          name = 'Newbie',
        },
      },
      auto_save_interval = 300,
      backdrop = { backdrop = 20, enabled = true },
      custom_languages = {},
      enabled = true,
      gamification_enabled = true,
      icon_engine = 'mini',
      ignore_ft = { 'conf', 'config', 'dosini', 'hyprlang', 'json', 'make', 'markdown', 'toml', 'yaml' },
      items = { enabled = true },
      levels = {
        { level = 2, title = 'Newbie' },
        { level = 40, title = 'Sergeant' },
        { level = 80, title = 'Lieutenant' },
      },
      notifications = { achievements = true, enabled = true, level_up = true },
      override_levels = false,
      xp_rewards = { char = 1, line = 2, save = 7.5 },
    })

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = {
        ['<leader>T'] = { group = '+Triforce' },
        ['<leader>TC'] = {
          function()
            vim.cmd.Triforce('config')
          end,
          desc('Show Config'),
        },
        ['<leader>Tp'] = {
          function()
            vim.cmd.Triforce('profile')
          end,
          desc('Show Profile'),
        },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
