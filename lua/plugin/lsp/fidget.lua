---@module 'lazy'
return { ---@type LazySpec
  'j-hui/fidget.nvim',
  version = false,
  config = function()
    require('fidget').setup({
      logger = {
        enable = true,
        float_precision = 0.01,
        level = vim.log.levels.WARN,
        max_size = 10000,
        path = ('%s/fidget.nvim.log'):format(vim.fn.stdpath('cache')),
      },
      notification = {
        configs = { default = require('fidget.notification').default_config },
        filter = vim.log.levels.INFO,
        history_size = 128,
        override_vim_notify = false,
        poll_rate = 10,
        redirect = function(msg, level, opts)
          if opts and opts.on_open then
            return require('fidget.integration.nvim-notify').delegate(msg, level, opts)
          end
        end,
        view = {
          align = 'message',
          group_separator = '---',
          group_separator_hl = 'Comment',
          icon_separator = ' ',
          line_margin = 1,
          reflow = false,
          render_message = function(msg, cnt)
            return cnt == 1 and msg or ('(%dx) %s'):format(cnt, msg)
          end,
          stack_upwards = true,
        },
        window = {
          align = 'bottom',
          avoid = {},
          border = 'none',
          h_align = 'right',
          max_height = 0,
          max_width = 0,
          normal_hl = 'Comment',
          relative = 'editor',
          tabstop = 8,
          winblend = 100,
          x_padding = 1,
          y_padding = 0,
          zindex = 45,
        },
      },
      progress = {
        clear_on_detach = function(client_id)
          local client = vim.lsp.get_client_by_id(client_id)
          return client and client.name or nil
        end,
        display = {
          done_icon = '✔',
          done_style = 'Constant',
          done_ttl = 3,
          format_annote = function(msg)
            return msg.title
          end,
          format_group_name = function(group)
            return tostring(group)
          end,
          format_message = require('fidget.progress.display').default_format_message,
          group_style = 'Title',
          icon_style = 'Question',
          overrides = { rust_analyzer = { name = 'rust-analyzer' } },
          priority = 30,
          progress_icon = { 'dots' },
          progress_style = 'WarningMsg',
          progress_ttl = math.huge,
          render_limit = 16,
          skip_history = true,
        },
        ignore = {},
        ignore_done_already = false,
        ignore_empty_message = false,
        lsp = { log_handler = false, progress_ringbuf_size = 0 },
        notification_group = function(msg)
          return msg.lsp_client.name
        end,
        poll_rate = 0,
        suppress_on_insert = false,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
