---@module 'lazy'
return { ---@type LazySpec
  'roobert/hoversplit.nvim',
  dev = true,
  version = false,
  config = function()
    require('hoversplit').setup({
      conceallevel = 0,
      key_bindings = {
        split_remain_focused = '<leader>hs',
        vsplit_remain_focused = '<leader>hv',
        split = '<leader>hS',
        vsplit = '<leader>hV',
      },
    })
    require('user_api.config').keymaps.set({ n = { ['<leader>h'] = { group = '+HoverSplit' } } })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
