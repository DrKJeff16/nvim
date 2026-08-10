---@module 'lazy'
return { ---@type LazySpec
  'NStefan002/screenkey.nvim',
  dev = true,
  event = 'VeryLazy',
  version = false,
  cond = not require('user_api').check.in_console(),
  config = function()
    require('screenkey').setup({
      clear_after = 3,
      compress_after = 2,
      disable = { buftypes = { 'terminal' }, filetypes = {}, modes = { 'i', 't' } },
      display_behind = {},
      display_infront = {},
      emit_events = true,
      filter = function(keys)
        return vim.tbl_map(function(value) ---@param value screenkey.queued_key
          value.key = (require('screenkey').statusline_component_is_active() and value.key == '%') and '%%' or value.key
          return value
        end, keys)
      end,
      group_mappings = true,
      hl_groups = {
        ['screenkey.hl.key'] = { link = 'DiagnosticOk' },
        ['screenkey.hl.map'] = { link = 'DiagnosticWarn' },
        ['screenkey.hl.sep'] = { bg = 'red', fg = 'blue' },
      },
      keys = {
        ['<BS>'] = '󰌥',
        ['<CR>'] = '󰌑',
        ['<DEL>'] = 'Del',
        ['<DOWN>'] = '',
        ['<END>'] = 'End',
        ['<ESC>'] = 'Esc',
        ['<F10>'] = '󱊴',
        ['<F11>'] = '󱊵',
        ['<F12>'] = '󱊶',
        ['<F1>'] = '󱊫',
        ['<F2>'] = '󱊬',
        ['<F3>'] = '󱊭',
        ['<F4>'] = '󱊮',
        ['<F5>'] = '󱊯',
        ['<F6>'] = '󱊰',
        ['<F7>'] = '󱊱',
        ['<F8>'] = '󱊲',
        ['<F9>'] = '󱊳',
        ['<HOME>'] = 'Home',
        ['<INSERT>'] = 'Ins',
        ['<LEFT>'] = '',
        ['<PAGEDOWN>'] = 'PgDn',
        ['<PAGEUP>'] = 'PgUp',
        ['<RIGHT>'] = '',
        ['<SPACE>'] = '␣',
        ['<TAB>'] = '󰌒',
        ['<UP>'] = '',
        ['<leader>'] = '<leader>',
        ['ALT'] = 'Alt',
        ['CTRL'] = 'Ctrl',
        ['SUPER'] = 'Super',
      },
      log = { filepath = vim.fs.joinpath(vim.fn.stdpath('state'), 'screenkey.log'), min_level = vim.log.levels.OFF },
      notify_method = 'notify',
      separator = ' ',
      show_leader = true,
      win_opts = {
        anchor = 'NW',
        border = 'rounded',
        col = math.floor((vim.o.columns - 60) / 2) - 1,
        focusable = false,
        height = 3,
        noautocmd = false,
        relative = 'editor',
        row = 0,
        style = 'minimal',
        title = {
          { 'Sc', 'DiagnosticOk' },
          { 're', 'DiagnosticWarn' },
          { 'en', 'DiagnosticInfo' },
          { 'key', 'DiagnosticError' },
        },
        title_pos = 'center',
        width = 60,
        zindex = 70,
      },
    })

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = { ['<leader><C-s>'] = { require('screenkey').toggle, desc('Toggle Screenkey') } },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
