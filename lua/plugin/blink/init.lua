---@module 'lazy'
return { ---@type LazySpec
  'saghen/blink.nvim',
  lazy = false,
  version = false,
  build = require('user_api.check').executable('cargo') and 'cargo build --release' or false,
  config = function()
    require('blink').setup({
      chartoggle = { enabled = true },
      tree = { enabled = true },
    })

    local desc = require('user_api.maps').desc
    require('user_api.config.keymaps').set({
      n = {
        ['<C-;>'] = {
          function()
            require('blink.chartoggle').toggle_char_eol(';')
          end,
          desc('Toggle `;` at EOL'),
        },
        ['<C-,>'] = {
          function()
            require('blink.chartoggle').toggle_char_eol(',')
          end,
          desc('Toggle `,` at EOL'),
        },
        ['<C-e>'] = {
          function()
            vim.cmd.BlinkTree('reveal')
          end,
          desc('Reveal Current File in Tree'),
        },
        ['<leader>B'] = { group = 'blink.nnvim' },
        ['<leader>Bt'] = { group = 'blink.tree' },
        ['<leader>Btt'] = {
          function()
            vim.cmd.BlinkTree('toggle')
          end,
          desc('Reveal Current File in Tree'),
        },
        ['<leader>Btf'] = {
          function()
            vim.cmd.BlinkTree('toggle-focus')
          end,
          desc('Toggle File Tree Focus'),
        },
      },
      v = {
        ['<C-;>'] = {
          function()
            require('blink.chartoggle').toggle_char_eol(';')
          end,
          desc('Toggle `;` at EOL'),
        },
        ['<C-,>'] = {
          function()
            require('blink.chartoggle').toggle_char_eol(',')
          end,
          desc('Toggle `,` at EOL'),
        },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
