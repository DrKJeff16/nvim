---@class UserAPI
local User = {}

User.opts = require('user_api.opts')
User.distro = require('user_api.distro')
User.config = require('user_api.config')

function User.disable_netrw()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

---@param commands table<string, User.Commands.CmdSpec>|nil
---@param verbose boolean
---@overload fun()
---@overload fun(commands: table<string, User.Commands.CmdSpec>)
function User.setup(commands, verbose)
  require('user_api.check.exists').validate({
    commands = { commands, { 'table', 'nil' }, true },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  verbose = verbose ~= nil and verbose or false

  require('user_api.commands').setup(commands or {})
  require('user_api.update').setup()

  User.opts.setup()
  User.distro.setup(verbose)

  User.config.neovide.setup()

  User.config.keymaps.set({ n = { ['<leader>U'] = { group = '+User API' } } })
end

local M = setmetatable(User, { ---@type UserAPI
  __index = User,
  __newindex = function()
    vim.notify('User API is Read-Only!', vim.log.levels.ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
