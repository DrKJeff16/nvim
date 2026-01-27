---@diagnostic disable:missing-fields
---@module 'lazy'
return { ---@type LazySpec
  'folke/noice.nvim',
  version = false,
  dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify', 'nvim-mini/mini.nvim' },
  cond = not require('user_api.check').in_console(),
  config = function()
    require('noice').setup({
      throttle = 1000 / 30,
      cmdline = {
        enabled = true,
        view = 'cmdline_popup', ---@type 'cmdline_popup'|'cmdline'
        format = { ---@type NoiceFormatOptions
          cmdline = { pattern = '^:', icon = '', lang = 'vim' },
          search_down = {
            kind = 'search',
            pattern = '^/',
            icon = ' ',
            lang = 'regex',
          },
          search_up = {
            kind = 'search',
            pattern = '^%?',
            icon = ' ',
            lang = 'regex',
          },
          filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
          lua = {
            pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
            icon = '',
            lang = 'lua',
          },
          help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
          input = { view = 'cmdline_input', icon = '󰥻 ' },
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
      popupmenu = {
        enabled = true,
        backend = 'nui',
        kind_icons = { ---@type NoicePopupmenuItemKind|false
          Class = ' ',
          Color = ' ',
          Constant = ' ',
          Constructor = ' ',
          Enum = '了 ',
          EnumMember = ' ',
          Field = ' ',
          File = ' ',
          Folder = ' ',
          Function = ' ',
          Interface = ' ',
          Keyword = ' ',
          Method = 'ƒ ',
          Module = ' ',
          Property = ' ',
          Snippet = ' ',
          Struct = ' ',
          Text = ' ',
          Unit = ' ',
          Value = ' ',
          Variable = ' ',
        },
        opts = {},
      },
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
          ['cmp.entry.get_documentation'] = false,
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
        lsp_doc_border = true,
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

    if require('user_api.check.exists').module('telescope') then
      require('telescope').load_extension('noice')

      local desc = require('user_api.maps').desc
      require('user_api.config').keymaps.set({
        n = {
          ['<leader><C-t>ep'] = { ':Telescope projects<CR>', desc('Project Picker') },
          ['<leader>pT'] = { ':Telescope projects<CR>', desc('Project Telescope Picker') },
        },
      })
    end
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
