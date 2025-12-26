---@module 'lazy'

return { ---@type LazySpec
  '2kabhishek/co-author.nvim',
  version = false,
  ft = { 'gitcommit', 'gitrebase' },
  dependencies = { 'folke/snacks.nvim' },
  config = function()
    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
      n = { ['<leader>Ga'] = { vim.cmd.CoAuthor, desc('Run `:CoAuthor`') } },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
