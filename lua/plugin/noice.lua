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
      throttle = 1000 / 25,
      cmdline = {
        enabled = true,
        view = 'cmdline_popup', ---@type 'cmdline_popup'|'cmdline'
        format = { ---@type NoiceFormatOptions
          cmdline = { pattern = '^:', icon = ' ', lang = 'vim' },
          filter = { pattern = { '^:%s*Redir%s+!', '^:%s*!' }, icon = '$', title = 'Shell', lang = 'bash' },
          help = { pattern = '^:%s*he?l?p?%s+', title = 'Help', icon = '' },
          input = { view = 'cmdline_input', title = 'Input', icon = '󰥻 ' },
          lua = {
            pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
            icon = '',
            title = 'Lua',
            lang = 'lua',
          },
          redir = { pattern = '^:%s*Redir%s+', title = 'Redirect (Float)', icon = '󰥼', lang = 'vim' },
          redir_lua = {
            pattern = '^:%s*Redir%s+lua%s+',
            icon = '󰥼',
            title = 'Redirect Lua (Float)',
            lang = 'lua',
          },
          redir_lua_split = {
            pattern = '^:%s*Redir!%s+lua%s+',
            icon = '󰥼󰥼',
            title = 'Redirect Lua (Split)',
            lang = 'lua',
          },
          redir_set = { pattern = '^:%s*Redir%s+set%s+', title = 'Global Options (Float)', icon = '<', lang = 'vim' },
          redir_set_split = {
            pattern = '^:%s*Redir!%s+set%s+',
            title = 'Global Options (Split)',
            icon = '<<',
            lang = 'vim',
          },
          redir_setlocal = {
            pattern = '^:%s*Redir%s+setlocal%s+',
            title = 'Local Options (Float)',
            icon = '<',
            lang = 'vim',
          },
          redir_setlocal_split = {
            pattern = '^:%s*Redir!%s+setlocal%s+',
            title = 'Local Options (Split)',
            icon = '<<',
            lang = 'vim',
          },
          redir_shell = { pattern = '^:%s*Redir%s+!', title = 'Redirect Shell (Float)', icon = '󰥼$', lang = 'bash' },
          redir_shell_split = {
            pattern = '^:%s*Redir!%s+!',
            title = 'Redirect Shell (Split)',
            icon = '󰥼󰥼$',
            lang = 'bash',
          },
          redir_split = { pattern = '^:%s*Redir!%s+', title = 'Redirect (Split)', icon = '󰥼󰥼', lang = 'vim' },
          redir_verbose = {
            pattern = '^:%s*Redir%s+verbo?s?e?%s+',
            title = 'Verbose Redirect (Float)',
            icon = '󰥼󰦨',
            lang = 'vim',
          },
          redir_verbose_split = {
            pattern = '^:%s*Redir!%s+verbo?s?e?%s+',
            title = 'Verbose Redirect (Split)',
            icon = '<󰥼󰦨',
            lang = 'vim',
          },
          search_down = { kind = 'search', title = 'Search Down', pattern = '^/', icon = ' ', lang = 'regex' },
          search_up = { kind = 'search', title = 'Search Up', pattern = '^%?', icon = ' ', lang = 'regex' },
          set = { pattern = '^:%s*set%s+', title = 'Global Options', icon = '', lang = 'vim' },
          setlocal = { pattern = '^:%s*setlocal%s+', title = 'Local Options', icon = '', lang = 'vim' },
          verbose = { pattern = '^:%s*verbo?s?e?%s+', title = 'Verbose', icon = '󰦨', lang = 'vim' },
        },
      },
      messages = {
        enabled = true,
        view = 'notify',
        view_error = 'notify',
        view_history = 'messages',
        view_search = 'virtualtext',
        view_warn = 'notify',
      },
      popupmenu = { enabled = true, backend = 'nui' },
      redirect = { view = 'popup', filter = { event = 'msg_show' }, opts = { enter = true, format = 'details' } },
      commands = {
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
        errors = {
          filter = { error = true, has = true, warning = true },
          filter_opts = { reverse = true },
          opts = { enter = true, format = 'details' },
          view = 'popup',
        },
      },
      notify = { enabled = true, view = 'notify', opts = {} },
      lsp = {
        progress = {
          enabled = false,
          format = 'lsp_progress',
          format_done = 'lsp_progress_done',
          opts = { border = 'rounded', enter = false, focusable = false },
          throttle = 1000 / 30,
          view = 'mini',
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
        message = { enabled = true, view = 'notify', opts = {} },
        hover = { enabled = true, silent = false, opts = {}, view = nil },
        signature = {
          auto_open = { enabled = true, trigger = true, luasnip = true, throttle = 500 },
          enabled = true,
          opts = {},
          view = nil,
        },
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
      },
      all = { filter = {}, opts = { enter = true, format = 'details' }, view = 'split' },
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
      health = { checker = true },
      presets = {
        bottom_search = true,
        command_palette = true,
        inc_rename = false,
        long_message_to_split = true,
        lsp_doc_border = false,
      },
      views = { split = { enter = true } },
      routes = {
        { filter = { event = 'msg_show', kind = 'search_count' }, opts = { skip = true } },
        { view = 'split', filter = { event = 'msg_show', min_height = 15 } },
      },
      status = {},
      format = {},
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
