---@module 'lazy'
return { ---@type LazySpec
  'gbprod/yanky.nvim',
  version = false,
  dependencies = { 'kkharji/sqlite.lua', 'nvim-telescope/telescope.nvim', 'folke/snacks.nvim' },
  config = function()
    require('yanky').setup({
      ring = {
        history_length = 100,
        storage = 'shada',
        storage_path = vim.fn.stdpath('data') .. '/databases/yanky.db',
        sync_with_numbered_registers = true,
        cancel_event = 'update',
        ignore_registers = { '_' },
        update_register_on_cycle = false,
        permanent_wrapper = nil,
      },
      picker = { select = { action = nil }, telescope = { use_default_mappings = true } },
      system_clipboard = { sync_with_ring = true, clipboard_register = nil },
      highlight = { on_put = true, on_yank = true, timer = 500 },
      preserve_cursor_position = { enabled = true },
      textobj = { enabled = true },
    })
    pcall(require('telescope').load_extension, 'yank_history')

    vim.keymap.set({ 'o', 'x' }, 'iy', function()
      require('yanky.textobj').last_put()
    end, {})
  end,
  keys = {
    { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank Text' },
    { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and indent right' },
    { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and indent left' },
    { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
    { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put before and indent left' },
    { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put after applying a filter' },
    { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put before applying a filter' },
    { '<C-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
    {
      'p',
      '<Plug>(YankyPutAfter)',
      mode = { 'n', 'x' },
      desc = 'Put yanked text after cursor',
    },
    {
      'P',
      '<Plug>(YankyPutBefore)',
      mode = { 'n', 'x' },
      desc = 'Put yanked text before cursor',
    },
    {
      'gp',
      '<Plug>(YankyGPutAfter)',
      mode = { 'n', 'x' },
      desc = 'Put yanked text after selection',
    },
    {
      'gP',
      '<Plug>(YankyGPutBefore)',
      mode = { 'n', 'x' },
      desc = 'Put yanked text before selection',
    },
    {
      '<C-p>',
      '<Plug>(YankyPreviousEntry)',
      desc = 'Select previous entry through yank history',
    },
    {
      ']p',
      '<Plug>(YankyPutIndentAfterLinewise)',
      desc = 'Put indented after cursor (linewise)',
    },
    {
      '[p',
      '<Plug>(YankyPutIndentBeforeLinewise)',
      desc = 'Put indented before cursor (linewise)',
    },
    {
      ']P',
      '<Plug>(YankyPutIndentAfterLinewise)',
      desc = 'Put indented after cursor (linewise)',
    },
    {
      '[P',
      '<Plug>(YankyPutIndentBeforeLinewise)',
      desc = 'Put indented before cursor (linewise)',
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
