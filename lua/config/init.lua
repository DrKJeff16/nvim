---@class NvimConfig
---@field autocmds Config.Autocmds
---@field colorschemes fun(color?: string)
---@field lazy Config.Lazy
---@field lsp Lsp.Server
---@field util Config.Util
local M = setmetatable({}, {
  __index = function(_, k)
    if require('user_api').check.module('config.' .. k) then
      return require('config.' .. k)
    end
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
