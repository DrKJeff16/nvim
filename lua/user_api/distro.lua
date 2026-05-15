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

  if require('user_api.distro.termux').is_distro() then
    require('user_api.distro.termux').setup()
    if verbose then
      vim.notify('Termux distribution detected...', vim.log.levels.INFO)
    end
  elseif require('user_api.distro.archlinux').is_distro() then
    require('user_api.distro.archlinux').setup()
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
  if distro == 'termux' then
    return require('user_api.distro.termux').is_distro()
  end
  return require('user_api.distro.termux').is_distro()
end

local Distro = setmetatable(M, { ---@type User.Distro
  __index = function(self, k)
    if require('user_api.check').module('user_api.distro.' .. k) then
      return require('user_api.distro.' .. k)
    end
    return rawget(self, k) or nil
  end,
})

return Distro
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
