---@class User.Distro
local Distro = {}

Distro.archlinux = require('user_api.distro.archlinux')
Distro.termux = require('user_api.distro.termux')

---@param verbose boolean
---@overload fun()
function Distro.setup(verbose)
  require('user_api.check').validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
  verbose = verbose ~= nil and verbose or false

  if Distro.termux.validate() then
    Distro.termux.setup()
    if verbose then
      vim.notify('Termux distribution detected...', vim.log.levels.INFO)
    end
    return
  end
  if Distro.archlinux.validate() then
    Distro.archlinux.setup()
    if verbose then
      vim.notify('Arch Linux distribution detected...', vim.log.levels.INFO)
    end
    return
  end
end

local M = setmetatable(Distro, { ---@type User.Distro
  __index = Distro,
  __newindex = function()
    vim.notify('User.Distro is Read-Only!', vim.log.levels.ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
