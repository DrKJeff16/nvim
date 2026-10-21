local Util = require('user_api.util')

---@generic T: table, F
---@param t T
---@param k any
---@param fallback F
---@return F fallback
local function get(t, k, fallback)
  return Util.get(t, k, function()
    return Util.rawset(t, k, fallback)
  end, true)
end

---@class User.Config
---@field keymaps User.Config.Keymaps
---@field neovide User.Config.Neovide
local M = {}

setmetatable(M, {
  __index = function(self, k) ---@param self User.Config
    local raw = Util.get(self, k)
    if raw ~= nil then
      return raw
    end

    if type(k) ~= 'string' then
      return
    end

    ---@cast k string
    if require('user_api.check').module('user_api.config.' .. k) then
      return get(self, k, require('user_api.config.' .. k))
    end
    require('user_api.backtrace')(vim.log.levels.ERROR, ('Invalid key: `%s`'):format(k))
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
