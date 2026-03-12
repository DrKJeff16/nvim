---@module 'lazy'

function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require('oil').get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ':~')
  end

  return vim.api.nvim_buf_get_name(0)
end

return { ---@type LazySpec
  'stevearc/oil.nvim',
  lazy = false,
  version = false,
  dependencies = { 'nvim-mini/mini.icons' },
  config = function()
    require('oil').setup({
      default_file_explorer = false,
      columns = {
        'icon',
        'permissions',
        'size',
        -- "mtime",
      },
      buf_options = { buflisted = false, bufhidden = 'hide' },
      win_options = {
        wrap = false,
        winbar = '%!v:lua.get_oil_winbar()',
        signcolumn = 'no',
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
      },
      delete_to_trash = false,
      skip_confirm_for_simple_edits = false,
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms = 2000,
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = 'unmodified', ---@type 'unmodified'|boolean
      },
      constrain_cursor = 'editable', ---@type 'editable'|'name'|false
      watch_for_changes = true,
      keymaps = {
        ['-'] = { 'actions.parent', mode = 'n' },
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-l>'] = 'actions.refresh',
        ['<C-p>'] = 'actions.preview',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<CR>'] = 'actions.select',
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        gs = { 'actions.change_sort', mode = 'n' },
        gx = 'actions.open_external',
      },
      use_default_keymaps = true,
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, _)
          return name:match('^%.') ~= nil
        end,
        natural_order = true, ---@type 'fast'|boolean
        case_insensitive = false,
        sort = { { 'type', 'asc' }, { 'name', 'asc' } },
      },
      float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
        win_options = { winblend = 0 },
        preview_split = 'auto', ---@type 'auto'|'left'|'right'|'above'|'below'
        override = function(conf)
          return conf
        end,
      },
      preview_win = {
        update_on_cursor_moved = true,
        preview_method = 'fast_scratch', ---@type 'load'|'scratch'|'fast_scratch'
      },
      confirmation = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        max_height = 0.9,
        min_height = { 5, 0.1 },
        win_options = { winblend = 0 },
      },
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = nil,
        minimized_border = 'none',
        win_options = { winblend = 0 },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
