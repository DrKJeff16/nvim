---@module 'lazy'

local User = require('user_api')

---@generic T: table, F
---@param t T
---@param k any
---@param fallback F
---@return F fallback
local function get(t, k, fallback)
  return User.util.get(t, k, function()
    return User.util.rawset(t, k, fallback)
  end, true)
end

---@class NvimConfig
---@field autocmds Config.Autocmds
---@field colorschemes (fun())|(fun(color: string))
---@field lazy Config.Lazy
---@field lsp Lsp.Server
---@field util Config.Util

---@diagnostic disable-next-line:missing-fields
local M = {} ---@type NvimConfig|(fun(mod: 'autocmds'))|(fun(mod: 'lsp'))|(fun(mod: 'colorschemes'))|(fun(mod: 'colorschemes', theme: string))|(fun(mod: 'lazy', spec: table<string, LazySpec|string|LazyPluginSpec|boolean>|LazyToggle))

setmetatable(M, {
  __index = function(self, k) ---@param self NvimConfig
    local raw = User.util.get(self, k)
    if raw ~= nil then
      return raw
    end

    if type(k) ~= 'string' then
      return
    end

    ---@cast k string
    if User.check.module('config.' .. k) then
      return get(self, k, require('config.' .. k))
    end
  end,
  ---@param self NvimConfig
  ---@param mod string
  ---@param ... any
  ---@overload fun(self: NvimConfig, mod: string)
  __call = function(self, mod, ...)
    User.check.validate({ mod = { mod, { 'string' } } })

    local module = self[mod] --[[@as Config.Autocmds|(fun())|(fun(color: string))|Config.Lazy|Lsp.Server]]
    assert(module ~= nil, ('Unable to locate `%s`'):format(mod))
    if vim.is_callable(module) then
      ---@cast module (fun()|fun(color: string))
      module(...)
    elseif module.setup ~= nil and vim.is_callable(module.setup) then
      ---@cast module Config.Autocmds|Config.Lazy|Lsp.Server
      module.setup(...)
    else
      error(('Invalid operations: `%s` and `%s.setup()`'):format(mod, mod))
    end
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
