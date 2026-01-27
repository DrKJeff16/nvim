---@module 'lazy'
return { ---@type LazySpec
  'nvim-treesitter/nvim-treesitter-context',
  cond = not require('user_api.check').in_console(),
  config = function()
    local Context = require('treesitter-context')
    Context.setup({
      enable = true,
      multiwindow = true,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = false,
      multiline_threshold = 20,
      trim_scope = 'outer',
      mode = 'cursor',
      zindex = 20,
      separator = nil,
      on_attach = nil, ---@type nil|fun(buf: integer): boolean
    })

    require('user_api.highlight').hl_from_dict({
      TreesitterContextBottom = { underline = true, sp = 'Grey' },
      TreesitterContextLineNumberBottom = { underline = true, sp = 'Grey' },
      TreesitterContextLineNumber = { link = 'LineNr' },
      TreesitterContextSeparator = { link = 'FloatBorder' },
      TreesitterContext = { link = 'NormalFloat' },
    })

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps.set({
      n = {
        ['<leader>C'] = { group = '+Context' },
        ['<leader>Cn'] = {
          function()
            Context.go_to_context(vim.v.count1)
          end,
          desc('Go To Current Context'),
        },
        ['<leader>Ct'] = {
          function()
            Context.toggle()
            local msg = Context.enabled() and 'Enabled' or 'Disabled'
            vim.notify(('%s TS Context'):format(msg))
          end,
          desc('Toggle Context'),
        },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
