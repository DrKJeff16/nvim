---@class UserAPI
local User = {}

function User.disable_netrw()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

---@param commands? table<string, User.Commands.CmdSpec>
---@param verbose? boolean
function User.setup(commands, verbose)
  require('user_api.check').validate({
    commands = { commands, { 'table', 'nil' }, true },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  verbose = verbose ~= nil and verbose or false

  require('user_api.commands').setup(commands or {})
  require('user_api.update').setup()

  require('user_api.opts').setup()
  require('user_api.distro').setup(verbose)

  require('user_api.config.neovide').setup()

  require('user_api.config.keymaps').set({ n = { ['<leader>U'] = { group = '+User API' } } })
end

local M = setmetatable(User, { ---@type UserAPI
  __index = User,
  __newindex = function()
    vim.notify('User API is Read-Only!', vim.log.levels.ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
