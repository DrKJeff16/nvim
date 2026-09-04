---@module 'lazy'
return { ---@type LazySpec
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  version = false,
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  cond = require('user_api').check.executable('tree-sitter'),
  config = function()
    require('Comment').setup({
      extra = { above = 'gcO', below = 'gco', eol = 'gcA' },
      ignore = 'nil',
      mappings = { basic = true, extra = true },
      opleader = { block = 'gb', line = 'gc' },
      padding = true,
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      post_hook = function()
        local win = vim.api.nvim_get_current_win()
        local r = vim.api.nvim_win_get_cursor(win)
        if vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf()) > r[1] then
          vim.api.nvim_win_set_cursor(win, { r[1] + 1, 0 })
        end
      end,
      sticky = true,
      toggler = { block = 'gbc', line = 'gcc' },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
