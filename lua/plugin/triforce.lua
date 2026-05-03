---@module 'lazy'
return { ---@type LazySpec
  'gisketch/triforce.nvim',
  dev = true,
  version = false,
  dependencies = { { 'nvzone/volt', dev = true } },
  config = function()
    require('triforce').setup({
      enabled = true,
      backdrop = { enabled = false, backdrop = 20 },
      gamification_enabled = true,
      notifications = { enabled = true, level_up = true, achievements = true },
      keymap = { show_profile = '<leader>Tp' },
      auto_save_interval = 300,
      override_levels = false,
      achievements = {
        {
          id = 'first_session',
          name = 'Starter',
          desc = 'Open up your first session',
          icon = '✨',
          check = function(stats)
            return stats.sessions >= 1
          end,
        },
        {
          id = 'first_300',
          name = 'Newbie',
          desc = 'Type 300 Characters',
          icon = '✨',
          check = function(stats)
            return stats.chars_typed >= 300
          end,
        },
      },
      ignore_ft = {
        'conf',
        'config',
        'dosini',
        'hyprlang',
        'json',
        'make',
        'markdown',
        'toml',
        'yaml',
      },
      custom_languages = {
        gleam = { icon = '✨', name = 'Gleam' },
        odin = { icon = '🔷', name = 'Odin' },
      },
      levels = {
        { level = 2, title = 'Newbie' },
        { level = 40, title = 'Sargeant' },
        { level = 80, title = 'Lieutenant' },
        { level = 100, title = 'Foo' },
      },
      xp_rewards = { char = 1, line = 2, save = 10 },
    })

    local desc = require('user_api.maps').new_desc
    require('user_api.config.keymaps').set({
      n = {
        ['<leader>T'] = { group = '+Triforce' },
        ['<leader>TC'] = {
          function()
            vim.cmd.Triforce('config')
          end,
          desc('Show Config'),
        },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
