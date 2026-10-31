local User = require('user_api')

---@class Config.Util
local M = {}

---@param name string
---@param callback function
---@return function install_flag
---@overload fun(name: string): install_flag: function
function M.flag_installed(name, callback)
  User.check.validate({
    name = { name, { 'string' } },
    callback = { callback, { 'function', 'nil' }, true },
  })
  assert(name ~= '', 'Unable to set `vim.g` var')

  return function()
    vim.g[(name:sub(1, 10) == 'installed_') and name or ('installed_' .. name)] = 1
    if callback then
      assert(vim.is_callable(callback), 'Callback is not callable')
      callback()
    end
  end
end

---A `config` function to call your plugin from a `lazy` spec.
--- ---
---@param mod_str string
---@param ret boolean
---@return unknown|nil|? module
---@overload fun(mod_str: string): module_call: function
---@overload fun(mod_str: string, ret: false): module_call: function
function M.require(mod_str, ret)
  User.check.validate({
    mod_str = { mod_str, { 'string' } },
    ret = { ret, { 'boolean', 'nil' }, true },
  })
  if ret == nil then
    ret = false
  end

  if not ret then
    return function()
      pcall(require, mod_str)
    end
  end

  local ok, mod = pcall(require, mod_str)
  if ok and mod then
    return mod
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
