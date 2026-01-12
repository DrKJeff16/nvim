---@class UserAPI
local User = {}

User.opts = require('user_api.opts')
User.distro = require('user_api.distro')
User.config = require('user_api.config')

function User.setup()
  require('user_api.commands').setup()
  require('user_api.update').setup()

  User.opts.setup()
  User.distro()

  require('user_api.util').setup_autocmd()

  User.config.neovide.setup()

  User.config.keymaps({ n = { ['<leader>U'] = { group = '+User API' } } })
end

local M = setmetatable(User, { ---@type UserAPI
  __index = User,
  __newindex = function()
    vim.notify('User API is Read-Only!', vim.log.levels.ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
