---@class User.Config
---@field keymaps User.Config.Keymaps
---@field neovide User.Config.Neovide
local M = setmetatable({}, {
  __index = function(_, k)
    if require('user_api.check').module('user_api.config.' .. k) then
      return require('user_api.config.' .. k)
    end
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
