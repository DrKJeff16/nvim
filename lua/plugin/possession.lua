---@module 'lazy'

return { ---@type LazySpec
  'gennaro-tedesco/nvim-possession',
  version = false,
  config = function()
    require('nvim-possession').setup({
      sessions = { sessions_prompt = 'Possession Prompt: ' },
      autoload = true,
      autosave = true,
      autoprompt = true,
      autoswitch = { enable = true, exclude_ft = { 'text', 'markdown' } },
      save_hook = function()
        vim.cmd.ScopeSaveState()
        local visible_buffers = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          visible_buffers[vim.api.nvim_win_get_buf(win)] = true
        end
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if not visible_buffers[bufnr] then
            pcall(vim.cmd.bdel, bufnr)
          end
        end
      end,
      post_hook = function()
        vim.cmd.ScopeLoadState()
        vim.lsp.buf.format()
        pcall(require('nvim-tree.api').tree.toggle)
      end,
      fzf_hls = {
        normal = 'Normal',
        preview_normal = 'Normal',
        border = 'Todo',
        preview_border = 'Constant',
      },
      fzf_winopts = { width = 0.5, preview = { vertical = 'right:30%' } },
      sort = require('nvim-possession.sorting').time_sort,
    })

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
      n = {
        ['<leader>s'] = { group = '+Session' },
        ['<leader>sl'] = { require('nvim-possession').list, desc('📌 List Sessions') },
        ['<leader>sn'] = { require('nvim-possession').new, desc('📌 Create New Session') },
        ['<leader>su'] = { require('nvim-possession').update, desc('📌 Update Current') },
        ['<leader>sd'] = { require('nvim-possession').delete, desc('📌 Delete Selected') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
