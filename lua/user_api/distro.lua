local validate = require('user_api.check').validate

---@class User.Distro
local M = {}

M.archlinux = require('user_api.distro.archlinux')
M.termux = require('user_api.distro.termux')

---@param verbose? boolean
function M.setup(verbose)
  validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
  verbose = verbose ~= nil and verbose or false

  if M.termux.is_distro() then
    M.termux.setup()
    if verbose then
      vim.notify('Termux distribution detected...', vim.log.levels.INFO)
    end
    return
  end
  if M.archlinux.is_distro() then
    M.archlinux.setup()
    if verbose then
      vim.notify('Arch Linux distribution detected...', vim.log.levels.INFO)
    end
    return
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
    return M.termux.is_distro()
  end
  return M.archlinux.is_distro()
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
