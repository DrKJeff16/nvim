---@module 'lazy'

function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require('oil').get_current_dir(bufnr)
  return dir and vim.fn.fnamemodify(dir, ':~') or vim.api.nvim_buf_get_name(bufnr)
end

return { ---@type LazySpec
  'stevearc/oil.nvim',
  lazy = false,
  version = false,
  dependencies = { 'nvim-mini/mini.icons' },
  config = function()
    require('oil').setup({
      buf_options = { buflisted = false, bufhidden = 'hide' },
      cleanup_delay_ms = 2000,
      columns = { 'icon', 'permissions', 'size' },
      confirmation = {
        max_height = 0.9,
        max_width = 0.9,
        min_height = { 5, 0.1 },
        min_width = { 40, 0.4 },
        win_options = { winblend = 0 },
      },
      constrain_cursor = 'editable',
      default_file_explorer = false,
      delete_to_trash = false,
      float = {
        max_height = 0,
        max_width = 0,
        override = function(conf)
          return conf
        end,
        padding = 2,
        preview_split = 'auto',
        win_options = { winblend = 0 },
      },
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
      lsp_file_methods = { autosave_changes = 'unmodified', enabled = true, timeout_ms = 1000 },
      preview_win = { preview_method = 'fast_scratch', update_on_cursor_moved = true },
      progress = {
        max_height = { 10, 0.9 },
        max_width = 0.9,
        min_height = { 5, 0.1 },
        min_width = { 40, 0.4 },
        minimized_border = 'none',
        win_options = { winblend = 0 },
      },
      prompt_save_on_select_new_entry = true,
      skip_confirm_for_simple_edits = false,
      use_default_keymaps = true,
      view_options = {
        case_insensitive = false,
        is_hidden_file = function(name)
          return name:match('^%.') ~= nil
        end,
        natural_order = true,
        show_hidden = true,
        sort = { { 'type', 'asc' }, { 'name', 'asc' } },
      },
      watch_for_changes = true,
      win_options = {
        concealcursor = 'nvic',
        conceallevel = 3,
        cursorcolumn = false,
        foldcolumn = '0',
        list = false,
        signcolumn = 'no',
        spell = false,
        winbar = '%!v:lua.get_oil_winbar()',
        wrap = false,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
