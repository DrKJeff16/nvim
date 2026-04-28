---@module 'lazy'
return { ---@type LazySpec
  'romgrk/barbar.nvim',
  event = 'VeryLazy',
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  config = function()
    require('barbar').setup({
      animation = true,
      auto_hide = false,
      tabpages = true,
      clickable = false,
      exclude_ft = {},
      focus_on_close = 'previous', ---@type 'left'|'previous'|'right'
      hide = { extensions = false, inactive = true },
      highlight_alternate = false,
      highlight_inactive_file_icons = false,
      highlight_visible = true,
      icons = {
        buffer_index = false,
        buffer_number = false,
        button = '',
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true },
          [vim.diagnostic.severity.WARN] = { enabled = true },
          [vim.diagnostic.severity.INFO] = { enabled = true },
          [vim.diagnostic.severity.HINT] = { enabled = false },
        },
        gitsigns = {
          added = { enabled = true, icon = '+' },
          changed = { enabled = true, icon = '~' },
          deleted = { enabled = true, icon = '-' },
        },
        filetype = { custom_colors = false, enabled = true },
        separator = { left = '▎', right = '' },
        separator_at_end = true,
        modified = { button = '●' },
        pinned = { button = '', filename = true },
        preset = 'default', ---@type 'default'|'powerline'|'slanted'
        alternate = { filetype = { enabled = false } },
        current = { buffer_index = true },
        inactive = { button = '×' },
        visible = { modified = { buffer_number = false } },
      },
      insert_at_end = true,
      insert_at_start = false,
      maximum_padding = 1,
      minimum_padding = 1,
      maximum_length = 30,
      minimum_length = 0,
      semantic_letters = true,
      sidebar_filetypes = {
        NvimTree = true,
        ['neo-tree'] = { event = 'BufWipeout' },
        Outline = { event = 'BufWinLeave', text = 'symbols-outline', align = 'right' },
      },
      letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
      sort = { ignore_case = false },
    })

    local desc = require('user_api.maps').desc
    require('user_api.config.keymaps').set({
      n = {
        ['<A-p>'] = { '<CMD>BufferPickDelete<CR>', desc('Buffer Pick Delete') },
        ['<C-p>'] = { '<CMD>BufferPick<CR>', desc('Buffer Pick') },
        ['<leader>bo'] = { group = 'Order Buffers' },
        ['<leader>b0'] = { '<CMD>BufferLast<CR>', desc('Last Buffer') },
        ['<leader>b1'] = { '<CMD>BufferGoto 1<CR>', desc('Goto Buffer 1') },
        ['<leader>b2'] = { '<CMD>BufferGoto 2<CR>', desc('Goto Buffer 2') },
        ['<leader>b3'] = { '<CMD>BufferGoto 3<CR>', desc('Goto Buffer 3') },
        ['<leader>b4'] = { '<CMD>BufferGoto 4<CR>', desc('Goto Buffer 4') },
        ['<leader>b5'] = { '<CMD>BufferGoto 5<CR>', desc('Goto Buffer 5') },
        ['<leader>b6'] = { '<CMD>BufferGoto 6<CR>', desc('Goto Buffer 6') },
        ['<leader>b7'] = { '<CMD>BufferGoto 7<CR>', desc('Goto Buffer 7') },
        ['<leader>b8'] = { '<CMD>BufferGoto 8<CR>', desc('Goto Buffer 8') },
        ['<leader>b9'] = { '<CMD>BufferGoto 9<CR>', desc('Goto Buffer 9') },
        ['<leader>b<'] = { '<CMD>BufferMovePrevious<CR>', desc('Move To Previous Buffer') },
        ['<leader>b>'] = { '<CMD>BufferMoveNext<CR>', desc('Move To Next Buffer') },
        ['<leader>bP'] = { '<CMD>BufferPin<CR>', desc('Pin Buffer') },
        ['<leader>bd'] = { '<CMD>BufferClose<CR>', desc('Close Buffer') },
        ['<leader>bn'] = { '<CMD>BufferNext<CR>', desc('Next Buffer') },
        ['<leader>bob'] = { '<CMD>BufferOrderByBufferNumber<CR>', desc('By Number') },
        ['<leader>bod'] = { '<CMD>BufferOrderByDirectory<CR>', desc('By Directory') },
        ['<leader>bol'] = { '<CMD>BufferOrderByLanguage<CR>', desc('By Language') },
        ['<leader>bon'] = { '<CMD>BufferOrderByName<CR>', desc('By Name') },
        ['<leader>bow'] = { '<CMD>BufferOrderByWindowNumber<CR>', desc('By Window Number') },
        ['<leader>bp'] = { '<CMD>BufferPrevious<CR>', desc('Previous Buffer') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
