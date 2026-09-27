local MODSTR = 'config.util'
local ERROR = vim.log.levels.ERROR
local validate = require('user_api').check.validate

---@class Config.Util
local M = {}

---@param name string
---@param callback? function
---@return function install_flag
function M.flag_installed(name, callback)
  validate({
    name = { name, { 'string' } },
    callback = { callback, { 'function', 'nil' }, true },
  })
  if name == '' then
    error(('(%s.flag_installed): Unable to set `vim.g` var'):format(MODSTR), ERROR)
  end

  return function()
    vim.g[(name:sub(1, 10) == 'installed_') and name or ('installed_' .. name)] = 1
    if callback and vim.is_callable(callback) then
      callback()
    end
  end
end

---A `config` function to call your plugin from a `lazy` spec.
--- ---
---@param mod_str string
---@return function module_call
function M.require(mod_str)
  validate({ mod_str = { mod_str, { 'string' } } })

  return function()
    pcall(require, mod_str)
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
