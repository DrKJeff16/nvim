---@module 'lazy'
return { ---@type LazySpec
  'NStefan002/screenkey.nvim',
  dev = true,
  version = false,
  cmd = 'Screenkey',
  cond = not require('user_api.check').in_console(),
  config = function()
    local SK = require('screenkey')
    SK.setup({
      win_opts = {
        row = 0,
        col = math.floor((vim.o.columns - 60) / 2) - 1,
        relative = 'editor',
        anchor = 'NW',
        width = 60,
        height = 3,
        border = 'rounded',
        title = {
          { 'Sc', 'DiagnosticOk' },
          { 're', 'DiagnosticWarn' },
          { 'en', 'DiagnosticInfo' },
          { 'key', 'DiagnosticError' },
        },
        title_pos = 'center',
        style = 'minimal',
        focusable = false,
        noautocmd = false,
        zindex = 70,
      },
      hl_groups = {
        ['screenkey.hl.key'] = { link = 'DiagnosticOk' },
        ['screenkey.hl.map'] = { link = 'DiagnosticWarn' },
        ['screenkey.hl.sep'] = { bg = 'red', fg = 'blue' },
      },
      compress_after = 2,
      clear_after = 3,
      emit_events = true,
      disable = {
        filetypes = {},
        buftypes = { 'terminal' },
        modes = { 'i', 't' },
      },
      show_leader = true,
      group_mappings = true,
      display_infront = {},
      display_behind = {},
      filter = function(keys)
        return vim.tbl_map(function(value) ---@param value screenkey.queued_key
          value.key = (SK.statusline_component_is_active() and value.key == '%') and '%%' or value.key

          return value
        end, keys)
      end,
      separator = ' ',
      keys = {
        ['<TAB>'] = '󰌒',
        ['<CR>'] = '󰌑',
        ['<ESC>'] = 'Esc',
        ['<SPACE>'] = '␣',
        ['<BS>'] = '󰌥',
        ['<DEL>'] = 'Del',
        ['<LEFT>'] = '',
        ['<RIGHT>'] = '',
        ['<UP>'] = '',
        ['<DOWN>'] = '',
        ['<HOME>'] = 'Home',
        ['<END>'] = 'End',
        ['<PAGEUP>'] = 'PgUp',
        ['<PAGEDOWN>'] = 'PgDn',
        ['<INSERT>'] = 'Ins',
        ['<F1>'] = '󱊫',
        ['<F2>'] = '󱊬',
        ['<F3>'] = '󱊭',
        ['<F4>'] = '󱊮',
        ['<F5>'] = '󱊯',
        ['<F6>'] = '󱊰',
        ['<F7>'] = '󱊱',
        ['<F8>'] = '󱊲',
        ['<F9>'] = '󱊳',
        ['<F10>'] = '󱊴',
        ['<F11>'] = '󱊵',
        ['<F12>'] = '󱊶',
        ['CTRL'] = 'Ctrl',
        ['ALT'] = 'Alt',
        ['SUPER'] = 'Super',
        ['<leader>'] = '<leader>',
      },
      notify_method = 'notify',
      log = {
        min_level = vim.log.levels.OFF,
        filepath = vim.fs.joinpath(vim.fn.stdpath('state'), 'screenkey.log'),
      },
    })

    local desc = require('user_api.maps').new_desc
    require('user_api.config.keymaps').set({
      n = { ['<leader><C-s>'] = { SK.toggle, desc('Toggle Screenkey') } },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
