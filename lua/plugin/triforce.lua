---@module 'lazy'
return { ---@type LazySpec
  'gisketch/triforce.nvim',
  dev = true,
  version = false,
  dependencies = { { 'nvzone/volt', dev = true } },
  config = function()
    require('triforce').setup({
      enabled = true,
      gamification_enabled = true,
      notifications = { enabled = true, level_up = true, achievements = true },
      keymap = { show_profile = '<leader>Tp' },
      auto_save_interval = 300,
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
      level_progression = {
        tier_1 = { min_level = 1, max_level = 15, xp_per_level = 600 },
        tier_2 = { min_level = 16, max_level = 30, xp_per_level = 1200 },
        tier_3 = { min_level = 31, max_level = math.huge, xp_per_level = 3000 },
      },
      levels = {
        { level = 2, title = 'Newbie' },
        { level = 40, title = 'Sargeant' },
        { level = 80, title = 'Lieutenant' },
      },
      xp_rewards = { char = 1, line = 2, save = 10 },
    })

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps.set({
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
