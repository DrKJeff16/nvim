---@class NvimConfig
---@field autocmds Config.Autocmds
---@field colorschemes fun(color?: string)
---@field lazy Config.Lazy
---@field lsp Lsp.Server
---@field util Config.Util
local M = setmetatable({}, {
  __index = function(self, k)
    local raw = rawget(self, k) or nil
    if raw then
      return raw
    end

    if require('user_api').check.module('config.' .. k) then
      rawset(self, k, require('config.' .. k))
      return require('config.' .. k)
    end
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
