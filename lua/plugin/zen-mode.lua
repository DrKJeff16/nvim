---@module 'lazy'
return { ---@type LazySpec
  'folke/zen-mode.nvim',
  version = false,
  cond = not require('user_api.check').in_console(),
  config = function()
    require('zen-mode').setup({
      window = {
        backdrop = 1,
        width = 0.9,
        height = 0.95,
        options = {
          signcolumn = 'no',
          number = false,
          cursorline = true,
          cursorcolumn = false,
          foldcolumn = '0',
          foldmethod = 'manual',
          list = false,
          wrap = true,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
          showtabline = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        todo = { enabled = true },
        kitty = { enabled = true, font = '+2' },
        alacritty = { enabled = true },
        wezterm = { enabled = true, font = '+4' },
      },
    })

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps.set({
      n = {
        ['<leader>Z'] = { group = '+Zen Mode' },
        ['<leader>Zo'] = { require('zen-mode').open, desc('Open Zen Mode') },
        ['<leader>Zd'] = { require('zen-mode').close, desc('Close Zen Mode') },
        ['<leader>Zt'] = { require('zen-mode').toggle, desc('Toggle Zen Mode') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
