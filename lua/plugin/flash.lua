---@module 'lazy'
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  config = function()
    local Flash = require('flash')
    Flash.setup({
      labels = 'abcdefghijklmnopqrstuvwxyz',
      search = {
        multi_window = true,
        forward = true,
        wrap = vim.o.wrap,
        mode = 'exact', ---@type Flash.Pattern.Mode
        incremental = false,
        exclude = { ---@type (string|fun(win: integer): focusable: boolean)[]
          'notify',
          'cmp_menu',
          'noice',
          'flash_prompt',
          function(win)
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
        trigger = '',
        max_length = false, ---@type integer|false
      },
      jump = {
        autojump = false,
        history = true,
        jumplist = true,
        nohlsearch = true,
        pos = 'start', ---@type "start"|"end"|"range"
        register = true,
      },
      label = {
        after = true, ---@type boolean|integer[]
        before = false, ---@type boolean|integer[]
        current = true,
        distance = true,
        exclude = '',
        format = function(opts) ---@param opts Flash.Format
          return { { opts.match.label, opts.hl_group } }
        end,
        min_pattern_length = 0,
        rainbow = { enabled = true, shade = 5 },
        reuse = 'lowercase', ---@type "lowercase"|"all"|"none"
        style = 'overlay', ---@type "eol"|"overlay"|"right_align"|"inline"
        uppercase = true,
      },
      highlight = {
        backdrop = true,
        groups = { match = 'FlashMatch', current = 'FlashCurrent', backdrop = 'FlashBackdrop', label = 'FlashLabel' },
        matches = true,
        priority = 5000,
      },
      pattern = '',
      continue = false,
      modes = { ---@type table<string, Flash.Config>
        search = {
          enabled = true,
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
          search = {},
        },
        char = {
          enabled = true,
          config = function(opts)
            opts.autohide = opts.autohide or (vim.fn.mode(true):find('no') and vim.v.operator == 'y')
            opts.jump_labels = opts.jump_labels and vim.v.count == 0 and vim.fn.reg_executing() == ''
          end,
          autohide = false,
          jump_labels = false,
          multi_line = true,
          label = { exclude = 'hjkliardc' },
          keys = { 'f', 'F', 't', 'T', ';', ',' },
          ---@param motion string
          ---@return table<string, "next"|"prev"|"right"|"left"> actions
          char_actions = function(motion)
            return { [';'] = 'next', [','] = 'prev', [motion:lower()] = 'next', [motion:upper()] = 'prev' }
          end,
          search = { wrap = false },
          highlight = { backdrop = true },
          jump = { register = false, autojump = false },
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
        remote = { remote_op = { restore = true, motion = true } },
      },
      prompt = {
        enabled = true,
        prefix = { { '⚡', 'FlashPromptIcon' } },
        win_config = {
          border = 'none',
          col = 0,
          height = 1,
          relative = 'editor',
          row = -1,
          width = 1,
          zindex = 1000,
        },
      },
      remote_op = { restore = true, motion = false },
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
