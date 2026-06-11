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
          search_down = {
            kind = 'search',
            title = 'Search Down',
            pattern = '^/',
            icon = ' ',
            lang = 'regex',
          },
          search_up = {
            kind = 'search',
            title = 'Search Up',
            pattern = '^%?',
            icon = ' ',
            lang = 'regex',
          },
          filter = {
            pattern = { '^:%s*Redir%s+!', '^:%s*!' },
            icon = '$',
            title = 'Shell',
            lang = 'bash',
          },
          lua = {
            pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
            icon = '',
            title = 'Lua',
            lang = 'lua',
          },
          help = { pattern = '^:%s*he?l?p?%s+', title = 'Help', icon = '' },
          set = { pattern = '^:%s*set%s+', title = 'Global Options', icon = '', lang = 'vim' },
          setlocal = { pattern = '^:%s*setlocal%s+', title = 'Local Options', icon = '', lang = 'vim' },
          input = { view = 'cmdline_input', title = 'Input', icon = '󰥻 ' },
          verbose = { pattern = '^:%s*verbo?s?e?%s+', title = 'Verbose', icon = '󰦨', lang = 'vim' },
          redir = { pattern = '^:%s*Redir%s+', title = 'Redirect (Float)', icon = '󰥼', lang = 'vim' },
          redir_split = { pattern = '^:%s*Redir!%s+', title = 'Redirect (Split)', icon = '󰥼󰥼', lang = 'vim' },
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
          redir_shell = { pattern = '^:%s*Redir%s+!', title = 'Redirect Shell (Float)', icon = '󰥼$', lang = 'bash' },
          redir_shell_split = {
            pattern = '^:%s*Redir!%s+!',
            title = 'Redirect Shell (Split)',
            icon = '󰥼󰥼$',
            lang = 'bash',
          },
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
        },
      },
      messages = {
        enabled = true,
        view = 'notify',
        view_error = 'notify',
        view_warn = 'notify',
        view_history = 'messages',
        view_search = 'virtualtext',
      },
      popupmenu = { enabled = true, backend = 'nui' },
      redirect = { ---@type NoiceRouteConfig
        view = 'popup',
        filter = { event = 'msg_show' },
        opts = { ---@type NoiceViewOptions
          enter = true,
          format = 'details',
        },
      },
      commands = {
        history = {
          view = 'split',
          opts = { enter = true, format = 'details' },
          filter = {
            any = {
              { event = 'notify' },
              { error = true },
              { warning = true },
              { event = 'msg_show', kind = { '' } },
              { event = 'lsp', kind = 'message' },
            },
          },
        },
        last = {
          view = 'popup',
          opts = { enter = true, format = 'details' },
          filter = {
            any = {
              { event = 'notify' },
              { error = true },
              { warning = true },
              { event = 'msg_show', kind = { '' } },
              { event = 'lsp', kind = 'message' },
            },
          },
          filter_opts = { count = 1 },
        },
        errors = {
          view = 'popup',
          opts = { enter = true, format = 'details' },
          filter = { error = true, has = true, warning = true }, ---@type NoiceFilter
          filter_opts = { reverse = true },
        },
      },
      notify = { enabled = true, view = 'notify', opts = {} },
      lsp = {
        progress = {
          enabled = false,
          format = 'lsp_progress', ---@type NoiceFormat|string
          format_done = 'lsp_progress_done', ---@type NoiceFormat|string
          throttle = 1000 / 30,
          view = 'mini',
          opts = { ---@type NoiceViewOptions
            enter = false,
            border = 'rounded',
            focusable = false,
          },
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
        message = { enabled = true, view = 'notify', opts = {} },
        hover = { enabled = true, silent = false, opts = {}, view = nil },
        signature = {
          enabled = true,
          view = nil,
          opts = {},
          auto_open = { enabled = true, trigger = true, luasnip = true, throttle = 500 },
        },
        documentation = {
          view = 'hover',
          opts = { ---@type NoiceViewOptions
            lang = 'markdown',
            replace = true,
            render = 'plain',
            format = { '{message}' },
            win_options = { concealcursor = 'n', conceallevel = 3 },
          },
        },
      },
      all = {
        view = 'split',
        opts = { enter = true, format = 'details' },
        filter = {},
      },
      markdown = {
        hover = {
          ['|(%S-)|'] = vim.cmd.help,
          ['%[.-%]%((%S-)%)'] = require('noice.util').open,
        },
        highlights = {
          ['|%S-|'] = '@text.reference',
          ['@%S+'] = '@parameter',
          ['^%s*(Parameters:)'] = '@text.title',
          ['^%s*(Return:)'] = '@text.title',
          ['^%s*(See also:)'] = '@text.title',
          ['{%S-}'] = '@parameter',
        },
      },
      health = { checker = true },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      views = { ---@type NoiceConfigViews
        split = { enter = true },
      },
      routes = { ---@type NoiceRouteConfig
        { filter = { event = 'msg_show', kind = 'search_count' }, opts = { skip = true } },
        { view = 'split', filter = { event = 'msg_show', min_height = 15 } },
      },
      status = {}, ---@type table<string, NoiceFilter>
      format = {}, ---@type NoiceFormatOptions
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
