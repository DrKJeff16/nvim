---@diagnostic disable:missing-fields
---@module 'lazy'
return { ---@type LazySpec
  'folke/noice.nvim',
  event = 'VeryLazy',
  version = false,
  dependencies = { 'MunifTanjim/nui.nvim' },
  cond = not require('user_api').check.in_console(),
  config = function()
    require('noice').setup({
      all = { filter = {}, opts = { enter = true, format = 'details' }, view = 'split' },
      cmdline = {
        enabled = true,
        format = {
          cmdline = { icon = ' ', lang = 'vim', pattern = '^:' },
          filter = { icon = '$', lang = 'bash', pattern = { '^:%s*Redir%s+!', '^:%s*!' }, title = 'Shell' },
          help = { icon = '', pattern = '^:%s*he?l?p?%s+', title = 'Help' },
          input = { icon = '󰥻 ', title = 'Input', view = 'cmdline_input' },
          redir = { icon = '󰥼', lang = 'vim', pattern = '^:%s*Redir%s+', title = 'Redirect (Float)' },
          redir_set = {
            icon = '<',
            lang = 'vim',
            pattern = '^:%s*Redir%s+set%s+',
            title = 'Global Options (Float)',
          },
          redir_shell = { icon = '󰥼$', lang = 'bash', pattern = '^:%s*Redir%s+!', title = 'Redirect Shell (Float)' },
          redir_split = { icon = '󰥼󰥼', lang = 'vim', pattern = '^:%s*Redir!%s+', title = 'Redirect (Split)' },
          search_down = { icon = ' ', kind = 'search', lang = 'regex', pattern = '^/', title = 'Search Down' },
          search_up = { icon = ' ', kind = 'search', lang = 'regex', pattern = '^%?', title = 'Search Up' },
          set = { icon = '', lang = 'vim', pattern = '^:%s*set%s+', title = 'Global Options' },
          setlocal = { icon = '', lang = 'vim', pattern = '^:%s*setlocal%s+', title = 'Local Options' },
          verbose = { icon = '󰦨', lang = 'vim', pattern = '^:%s*verbo?s?e?%s+', title = 'Verbose' },
          lua = {
            icon = '',
            lang = 'lua',
            pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
            title = 'Lua',
          },
          redir_lua = {
            icon = '󰥼',
            lang = 'lua',
            pattern = '^:%s*Redir%s+lua%s+',
            title = 'Redirect Lua (Float)',
          },
          redir_lua_split = {
            icon = '󰥼󰥼',
            lang = 'lua',
            pattern = '^:%s*Redir!%s+lua%s+',
            title = 'Redirect Lua (Split)',
          },
          redir_set_split = {
            icon = '<<',
            lang = 'vim',
            pattern = '^:%s*Redir!%s+set%s+',
            title = 'Global Options (Split)',
          },
          redir_setlocal = {
            icon = '<',
            lang = 'vim',
            pattern = '^:%s*Redir%s+setlocal%s+',
            title = 'Local Options (Float)',
          },
          redir_setlocal_split = {
            icon = '<<',
            lang = 'vim',
            pattern = '^:%s*Redir!%s+setlocal%s+',
            title = 'Local Options (Split)',
          },
          redir_shell_split = {
            icon = '󰥼󰥼$',
            lang = 'bash',
            pattern = '^:%s*Redir!%s+!',
            title = 'Redirect Shell (Split)',
          },
          redir_verbose = {
            icon = '󰥼󰦨',
            lang = 'vim',
            pattern = '^:%s*Redir%s+verbo?s?e?%s+',
            title = 'Verbose Redirect (Float)',
          },
          redir_verbose_split = {
            icon = '<󰥼󰦨',
            lang = 'vim',
            pattern = '^:%s*Redir!%s+verbo?s?e?%s+',
            title = 'Verbose Redirect (Split)',
          },
        },
        view = 'cmdline_popup',
      },
      commands = {
        errors = {
          filter = { error = true, has = true, warning = true },
          filter_opts = { reverse = true },
          opts = { enter = true, format = 'details' },
          view = 'popup',
        },
        history = {
          filter = {
            any = {
              { error = true },
              { event = 'lsp', kind = 'message' },
              { event = 'msg_show', kind = { '' } },
              { event = 'notify' },
              { warning = true },
            },
          },
          opts = { enter = true, format = 'details' },
          view = 'split',
        },
        last = {
          filter = {
            any = {
              { error = true },
              { event = 'lsp', kind = 'message' },
              { event = 'msg_show', kind = { '' } },
              { event = 'notify' },
              { warning = true },
            },
          },
          filter_opts = { count = 1 },
          opts = { enter = true, format = 'details' },
          view = 'popup',
        },
      },
      format = {},
      health = { checker = true },
      lsp = {
        documentation = {
          opts = {
            format = { '{message}' },
            lang = 'markdown',
            render = 'plain',
            replace = true,
            win_options = { concealcursor = 'n', conceallevel = 3 },
          },
          view = 'hover',
        },
        hover = { enabled = true, silent = false, opts = {} },
        message = { enabled = true, view = 'notify', opts = {} },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
        progress = {
          enabled = false,
          format = 'lsp_progress',
          format_done = 'lsp_progress_done',
          opts = { border = 'rounded', enter = false, focusable = false },
          throttle = 1000 / 30,
          view = 'mini',
        },
        signature = {
          auto_open = { enabled = true, trigger = true, luasnip = true, throttle = 500 },
          enabled = true,
          opts = {},
        },
      },
      markdown = {
        highlights = {
          ['@%S+'] = '@parameter',
          ['^%s*(Parameters:)'] = '@text.title',
          ['^%s*(Return:)'] = '@text.title',
          ['^%s*(See also:)'] = '@text.title',
          ['{%S-}'] = '@parameter',
          ['|%S-|'] = '@text.reference',
        },
        hover = { ['|(%S-)|'] = vim.cmd.help, ['%[.-%]%((%S-)%)'] = require('noice.util').open },
      },
      messages = {
        enabled = true,
        view = 'notify',
        view_error = 'notify',
        view_history = 'messages',
        view_search = 'virtualtext',
        view_warn = 'notify',
      },
      notify = { enabled = true, opts = {}, view = 'notify' },
      popupmenu = { enabled = true, backend = 'nui' },
      presets = {
        bottom_search = true,
        command_palette = true,
        inc_rename = false,
        long_message_to_split = true,
        lsp_doc_border = false,
      },
      redirect = { view = 'popup', filter = { event = 'msg_show' }, opts = { enter = true, format = 'details' } },
      routes = {
        { filter = { event = 'msg_show', kind = 'search_count' }, opts = { skip = true } },
        { view = 'split', filter = { event = 'msg_show', min_height = 15 } },
      },
      status = {},
      throttle = 1000 / 25,
      views = { split = { enter = true } },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
