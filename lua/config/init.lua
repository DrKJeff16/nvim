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

---@class NvimConfig
---@field autocmds Config.Autocmds
---@field colorschemes (fun())|(fun(color: string))
---@field lazy Config.Lazy
---@field lsp Lsp.Server
---@field util Config.Util
local M = {}

setmetatable(M, {
  __index = function(self, k) ---@param self NvimConfig
    local raw = Util.get(self, k)
    if raw ~= nil then
      return raw
    end

    if type(k) ~= 'string' then
      return
    end

    ---@cast k string
    if require('user_api').check.module('config.' .. k) then
      return get(self, k, require('config.' .. k))
    end
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
