---@class User.Config
---@field keymaps User.Config.Keymaps
---@field neovide User.Config.Neovide
local M = setmetatable({}, {
  __index = function(self, k)
    local raw = rawget(self, k) or nil
    if raw then
      return raw
    end

    if require('user_api.check').module('user_api.config.' .. k) then
      return require('user_api.util').rawset(self, k, require('user_api.config.' .. k))
    end
    require('user_api.backtrace')(vim.log.levels.ERROR, ('Invalid key: `%s`'):format(k))
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
