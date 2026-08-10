---@module 'lazy'
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  config = function()
    local Flash = require('flash')
    Flash.setup({
      continue = false,
      highlight = {
        backdrop = true,
        groups = { match = 'FlashMatch', current = 'FlashCurrent', backdrop = 'FlashBackdrop', label = 'FlashLabel' },
        matches = true,
        priority = 5000,
      },
      jump = { autojump = false, history = true, jumplist = true, nohlsearch = true, pos = 'start', register = true },
      labels = 'abcdefghijklmnopqrstuvwxyz',
      label = {
        after = true,
        before = false,
        current = true,
        distance = true,
        exclude = '',
        format = function(opts)
          return { { opts.match.label, opts.hl_group } }
        end,
        min_pattern_length = 0,
        rainbow = { enabled = true, shade = 5 },
        reuse = 'lowercase',
        style = 'overlay',
        uppercase = true,
      },
      pattern = '',
      modes = {
        char = {
          autohide = false,
          ---@param motion string
          ---@return table<string, "next"|"prev"|"right"|"left"> actions
          char_actions = function(motion)
            return { [';'] = 'next', [','] = 'prev', [motion:lower()] = 'next', [motion:upper()] = 'prev' }
          end,
          config = function(opts)
            opts.autohide = opts.autohide or (vim.fn.mode(true):find('no') and vim.v.operator == 'y')
            opts.jump_labels = opts.jump_labels and vim.v.count == 0 and vim.fn.reg_executing() == ''
          end,
          enabled = true,
          highlight = { backdrop = true },
          jump = { register = false, autojump = false },
          jump_labels = false,
          keys = { 'f', 'F', 't', 'T', ';', ',' },
          label = { exclude = 'hjkliardc' },
          multi_line = true,
          search = { wrap = false },
        },
        remote = { remote_op = { restore = true, motion = true } },
        search = {
          enabled = true,
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
          search = {},
        },
        treesitter = {
          highlight = { backdrop = true, matches = true },
          jump = { pos = 'range', autojump = true },
          label = { before = true, after = true, style = 'inline' },
          labels = 'abcdefghijklmnopqrstuvwxyz',
          search = { incremental = true },
        },
        treesitter_search = {
          jump = { pos = 'range' },
          label = { before = true, after = true, style = 'inline' },
          remote_op = { restore = true },
          search = { multi_window = true, wrap = true, incremental = false },
        },
      },
      prompt = {
        enabled = true,
        prefix = { { '⚡', 'FlashPromptIcon' } },
        win_config = { border = 'none', col = 0, height = 1, relative = 'editor', row = -1, width = 1, zindex = 1000 },
      },
      remote_op = { restore = true, motion = false },
      search = {
        exclude = {
          'cmp_menu',
          'flash_prompt',
          'noice',
          'notify',
          function(win)
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
        forward = true,
        incremental = false,
        max_length = false,
        mode = 'exact',
        multi_window = true,
        trigger = '',
        wrap = vim.o.wrap,
      },
    })

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      c = { ['<C-s>'] = { Flash.toggle, desc('Toggle Flash Search') } },
      n = {
        ['<leader><C-f>'] = { group = '+Flash' },
        ['<leader><C-f>S'] = { Flash.treesitter, desc('Flash Treesitter') },
        ['<leader><C-f>s'] = { Flash.jump, desc('Flash') },
      },
      o = {
        ['<leader><C-f>'] = { group = '+Flash' },
        ['<leader><C-f>R'] = { Flash.treesitter_search, desc('Flash Treesitter Search') },
        ['<leader><C-f>S'] = { Flash.treesitter, desc('Flash Treesitter') },
        ['<leader><C-f>r'] = { Flash.remote, desc('Remote Flash') },
        ['<leader><C-f>s'] = { Flash.jump, desc('Flash') },
      },
      x = {
        ['<leader><C-f>'] = { group = '+Flash' },
        ['<leader><C-f>R'] = { Flash.treesitter_search, desc('Flash Treesitter Search') },
        ['<leader><C-f>S'] = { Flash.treesitter, desc('Flash Treesitter') },
        ['<leader><C-f>s'] = { Flash.jump, desc('Flash') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
