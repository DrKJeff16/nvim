---@module 'lazy'
return { ---@type LazySpec
  'nvim-focus/focus.nvim',
  version = false,
  config = function()
    local Focus = require('focus')
    Focus.setup({
      enable = true,
      commands = true,
      autoresize = {
        enable = true,
        width = 0,
        height = 0,
        minwidth = 0,
        minheight = 0,
        focusedwindow_minwidth = 0,
        focusedwindow_minheight = 0,
        height_quickfix = math.floor(vim.o.lines * 0.4),
        equalise_min_cols = 0,
        equalise_min_rows = 0,
      },
      split = { bufnew = true, tmux = false },
      ui = {
        number = false,
        relativenumber = false,
        hybridnumber = false,
        absolutenumber_unfocussed = false,
        cursorline = false,
        cursorcolumn = false,
        colorcolumn = { enable = false },
        signcolumn = false,
        winhighlight = false,
      },
    })

    local ignore_filetypes = {
      'NvimTree',
      'TelescopePrompt',
      'fzf',
      'lazy',
      'neo-tree',
      'notify',
      'snacks_picker_input',
      'toggleterm',
    }
    local ignore_buftypes = { 'nofile', 'prompt', 'terminal', 'popup' }
    local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })
    vim.api.nvim_create_autocmd('WinEnter', {
      group = augroup,
      callback = function(ev)
        vim.w.focus_disable = vim.list_contains(ignore_buftypes, vim.bo[ev.buf].buftype) and true
          or false
      end,
      desc = 'Disable focus autoresize for BufType',
    })
    vim.api.nvim_create_autocmd('FileType', {
      group = augroup,
      callback = function(ev)
        vim.b.focus_disable = vim.list_contains(ignore_filetypes, vim.bo[ev.buf].filetype) and true
          or false
      end,
      desc = 'Disable focus autoresize for FileType',
    })

    local desc = require('user_api.maps').desc
    require('user_api.config.keymaps').set({
      n = {
        ['<C-l>'] = { Focus.split_nicely, desc('Split Nicely') },
        ['<C-w>s'] = { group = '+Split' },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
