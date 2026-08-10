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
      clickable = false,
      exclude_ft = {},
      focus_on_close = 'previous', ---@type 'left'|'previous'|'right'
      hide = { extensions = false, inactive = true },
      highlight_alternate = false,
      highlight_inactive_file_icons = false,
      highlight_visible = true,
      icons = {
        alternate = { filetype = { enabled = false } },
        buffer_index = false,
        buffer_number = false,
        button = '',
        current = { buffer_index = true },
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true },
          [vim.diagnostic.severity.HINT] = { enabled = false },
          [vim.diagnostic.severity.INFO] = { enabled = true },
          [vim.diagnostic.severity.WARN] = { enabled = true },
        },
        filetype = { custom_colors = false, enabled = true },
        gitsigns = {
          added = { enabled = true, icon = '+' },
          changed = { enabled = true, icon = '~' },
          deleted = { enabled = true, icon = '-' },
        },
        inactive = { button = '×' },
        modified = { button = '●' },
        pinned = { button = '', filename = true },
        preset = 'default',
        separator = { left = '▎', right = '' },
        separator_at_end = true,
        visible = { modified = { buffer_number = false } },
      },
      insert_at_end = true,
      insert_at_start = false,
      letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
      maximum_length = 30,
      maximum_padding = 1,
      minimum_length = 0,
      minimum_padding = 1,
      semantic_letters = true,
      sidebar_filetypes = {
        NvimTree = true,
        Outline = { event = 'BufWinLeave', text = 'symbols-outline', align = 'right' },
        ['neo-tree'] = { event = 'BufWipeout' },
      },
      sort = { ignore_case = false },
      tabpages = true,
    })

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = {
        ['<leader>bo'] = { group = 'Order Buffers' },
        ['<A-p>'] = { ':BufferPickDelete<CR>', desc('Buffer Pick Delete') },
        ['<C-p>'] = { ':BufferPick<CR>', desc('Buffer Pick') },
        ['<leader>b0'] = { ':BufferLast<CR>', desc('Last Buffer') },
        ['<leader>b1'] = { ':BufferGoto 1<CR>', desc('Goto Buffer 1') },
        ['<leader>b2'] = { ':BufferGoto 2<CR>', desc('Goto Buffer 2') },
        ['<leader>b3'] = { ':BufferGoto 3<CR>', desc('Goto Buffer 3') },
        ['<leader>b4'] = { ':BufferGoto 4<CR>', desc('Goto Buffer 4') },
        ['<leader>b5'] = { ':BufferGoto 5<CR>', desc('Goto Buffer 5') },
        ['<leader>b6'] = { ':BufferGoto 6<CR>', desc('Goto Buffer 6') },
        ['<leader>b7'] = { ':BufferGoto 7<CR>', desc('Goto Buffer 7') },
        ['<leader>b8'] = { ':BufferGoto 8<CR>', desc('Goto Buffer 8') },
        ['<leader>b9'] = { ':BufferGoto 9<CR>', desc('Goto Buffer 9') },
        ['<leader>b<'] = { ':BufferMovePrevious<CR>', desc('Move To Previous Buffer') },
        ['<leader>b>'] = { ':BufferMoveNext<CR>', desc('Move To Next Buffer') },
        ['<leader>bP'] = { ':BufferPin<CR>', desc('Pin Buffer') },
        ['<leader>bd'] = { ':BufferClose<CR>', desc('Close Buffer') },
        ['<leader>bn'] = { ':BufferNext<CR>', desc('Next Buffer') },
        ['<leader>bob'] = { ':BufferOrderByBufferNumber<CR>', desc('By Number') },
        ['<leader>bod'] = { ':BufferOrderByDirectory<CR>', desc('By Directory') },
        ['<leader>bol'] = { ':BufferOrderByLanguage<CR>', desc('By Language') },
        ['<leader>bon'] = { ':BufferOrderByName<CR>', desc('By Name') },
        ['<leader>bow'] = { ':BufferOrderByWindowNumber<CR>', desc('By Window Number') },
        ['<leader>bp'] = { ':BufferPrevious<CR>', desc('Previous Buffer') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
