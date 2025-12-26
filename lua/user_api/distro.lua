local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

---@class User.Distro
local Distro = {
  archlinux = require('user_api.distro.archlinux'),
  termux = require('user_api.distro.termux'),
}

local M = setmetatable(Distro, { ---@type User.Distro|fun(verbose?: boolean)
  __index = Distro,
  __newindex = function()
    vim.notify('User.Distro is Read-Only!', ERROR)
  end,
  __call = function(_, verbose) ---@param verbose? boolean
    if vim.fn.has('nvim-0.11') == 1 then
      vim.validate('verbose', verbose, { 'boolean', 'nil' }, true)
    else
      vim.validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
    end
    verbose = verbose ~= nil and verbose or false

    local msg = ''
    if Distro.termux.validate() then
      Distro.termux()
      msg = 'Termux distribution detected...'
    elseif Distro.archlinux.validate() then
      Distro.archlinux()
      msg = 'Arch Linux distribution detected...'
    end

    if verbose and msg ~= '' then
      vim.notify(msg, INFO)
    end
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
