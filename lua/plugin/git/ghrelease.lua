---@module 'lazy'
return { ---@type LazySpec
  'mesirendon/nvim-ghrelease',
  dev = true,
  version = false,
  opts = { keymaps = false },
  keys = {
    {
      '<leader>Gr',
      function()
        vim.cmd.GhRelease()
      end,
      desc = 'GitHub Release: Create',
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
