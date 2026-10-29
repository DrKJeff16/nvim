local Util = require('user_api.util')
local validate = require('user_api.check').validate

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

---@class User.Distro
---@field archlinux User.Distro.Archlinux
---@field termux User.Distro.Termux
local M = {}

setmetatable(M, {
  __index = function(self, k) ---@param self User.Distro
    local raw = Util.get(self, k)
    if raw ~= nil then
      return raw
    end

    if type(k) ~= 'string' then
      return
    end

    ---@cast k string
    if require('user_api.check').module('user_api.distro.' .. k) then
      return get(self, k, require('user_api.distro.' .. k))
    end
    require('user_api.backtrace')(vim.log.levels.ERROR, ('Invalid key: `%s`'):format(k))
  end,
})

---@param verbose boolean
---@overload fun()
function M.setup(verbose)
  validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
  if verbose == nil then
    verbose = false
  end

  if M.termux.is_distro() then
    M.termux.setup()
    if verbose then
      vim.notify('Termux distribution detected...', vim.log.levels.INFO)
    end
  elseif M.archlinux.is_distro() then
    M.archlinux.setup()
    if verbose then
      vim.notify('Arch Linux distribution detected...', vim.log.levels.INFO)
    end
  end
end

---@param distro 'termux'|'archlinux'
---@return boolean is_distro
function M.is_distro(distro)
  validate({ distro = { distro, { 'string' } } })

  if not vim.list_contains({ 'termux', 'archlinux' }, distro) then
    return false
  end
  return require('user_api.distro.' .. distro).is_distro() --[[@as boolean]]
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
