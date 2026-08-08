---@module 'lazy'
return { ---@type LazySpec
  'folke/which-key.nvim',
  lazy = false,
  priority = 1000,
  version = false,
  cond = require('user_api').check.vim_has('nvim-0.10'),
  config = function()
    require('which-key').setup({
      delay = 10, ---@type integer|fun(ctx: { keys: string, mode: string, plugin?: string }): integer
      preset = 'modern', ---@type false|'classic'|'modern'|'helix'
      notify = true,
      keys = { scroll_down = '<A-Down>', scroll_up = '<A-Up>' },
      show_help = true,
      show_keys = true,
      debug = false,
      disable = { ft = {}, bt = {} },
      spec = { ---@type wk.Spec
        {
          '<C-Space>',
          function()
            require('which-key').show({ global = false })
          end,
          desc = 'Buffer Local Keymaps (which_key)',
          mode = 'n',
        },
        {
          '<leader>?',
          function()
            require('which-key').show({ global = false })
          end,
          desc = 'Buffer Local Keymaps (which-key)',
          mode = 'n',
        },
      },
      defer = function(ctx) ---@param ctx { mode: string, operator: string }
        return not vim.list_contains({ 'o', 'v', 'V', '<C-v>', '<C-V>' }, ctx.operator)
      end,
      filter = function(mapping) ---@param mapping wk.Mapping
        return (mapping.desc and mapping.desc ~= '')
      end,
      plugins = {
        marks = true,
        presets = {
          g = true,
          motions = true,
          nav = true,
          operators = true,
          text_objects = true,
          windows = true,
          z = true,
        },
        registers = true,
        spelling = { enabled = false },
      },
      ---@diagnostic disable-next-line:missing-fields
      win = { ---@type wk.Win
        bo = { modifiable = false },
        border = 'single',
        no_overlap = false,
        padding = { 1, 2 },
        title = true,
        title_pos = 'center',
        wo = { winblend = require('user_api').check.in_console() and 0 or 50 },
        zindex = 1000,
      },
      layout = { align = 'center', spacing = 1, width = { min = 20, max = math.floor(vim.o.columns / 2) } },
      sort = { 'alphanum', 'case', 'mod', 'order', 'group', 'local' }, ---@type (string|wk.Sorter)[]
      expand = function(node)
        return not node.desc
      end,
      replace = {
        key = {
          function(key)
            return require('which-key.view').format(key)
          end,
          { '<Space>', 'SPC' },
        },
        desc = {
          { '<Plug>%((.*)%)', '%1' },
          { '^%+', '' },
          { '<[cC]md>', '' },
          { '<[cC][rR]>', '' },
          { '<[sS]ilent>', '' },
          { '^lua%s+', '' },
          { '^call%s+', '' },
          { '^:%s*', '' },
        },
      },
      icons = {
        breadcrumb = '»',
        separator = '➜',
        group = '+',
        ellipsis = '…',
        mappings = true,
        colors = true,
        rules = { ---@type wk.IconRule[]|false
          { pattern = 'toggleterm', icon = ' ', color = 'cyan' },
          { pattern = 'lsp', icon = ' ', color = 'purple' },
        },
        keys = {
          BS = '⌫ ',
          C = 'CTRL-',
          CR = '<CR>',
          Down = '',
          Esc = '<ESC>',
          F1 = '󱊫',
          F10 = '󱊴',
          F11 = '󱊵',
          F12 = '󱊶',
          F2 = '󱊬',
          F3 = '󱊭',
          F4 = '󱊮',
          F5 = '󱊯',
          F6 = '󱊰',
          F7 = '󱊱',
          F8 = '󱊲',
          F9 = '󱊳',
          Left = '',
          M = 'META-',
          NL = '󰌑 ',
          Right = '',
          S = 'SHIFT-',
          ScrollWheelDown = '󱕐 ',
          ScrollWheelUp = '󱕑 ',
          Space = '󱁐 ',
          Tab = '󰌒 ',
          Up = '',
        },
      },
      triggers = { { '<auto>', mode = 'nxso' }, { '<leader>', mode = { 'n', 'v' } }, { 'a', mode = { 'n', 'v' } } },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
