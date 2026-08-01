---@module 'lazy'
return { ---@type LazySpec
  'numToStr/Comment.nvim',
  version = false,
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'JoosepAlviste/nvim-ts-context-commentstring' },
  cond = require('user_api').check.executable('tree-sitter'),
  config = function()
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      post_hook = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        local r = unpack(vim.api.nvim_win_get_cursor(win))
        if vim.api.nvim_buf_line_count(bufnr) > r then
          vim.api.nvim_win_set_cursor(win, { r + 1, 0 })
        end
      end,
      extra = { above = 'gcO', below = 'gco', eol = 'gcA' },
      ignore = 'nil',
      mappings = { basic = true, extra = true },
      opleader = { line = 'gc', block = 'gb' },
      padding = true,
      sticky = true,
      toggler = { line = 'gcc', block = 'gbc' },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
