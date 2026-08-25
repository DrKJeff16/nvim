local validate = require('user_api.check').validate

---@class User.Distro
---@field archlinux User.Distro.Archlinux
---@field termux User.Distro.Termux
local M = {}

---@param verbose? boolean
function M.setup(verbose)
  validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
  if verbose == nil then
    verbose = false
  end

  local Termux = require('user_api.distro.termux')
  local Archlinux = require('user_api.distro.archlinux')
  if Termux.is_distro() then
    Termux.setup()
    if verbose then
      vim.notify('Termux distribution detected...', vim.log.levels.INFO)
    end
  elseif Archlinux.is_distro() then
    Archlinux.setup()
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

local Distro = setmetatable(M, { ---@type User.Distro
  __index = function(self, k)
    if require('user_api.check').module('user_api.distro.' .. k) then
      return require('user_api.distro.' .. k)
    end
    local res = rawget(self, k)
    if res then
      return res
    end
    require('user_api.backtrace')(vim.log.levels.ERROR, ('Invalid key: `%s`'):format(k))
  end,
})

return Distro
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
