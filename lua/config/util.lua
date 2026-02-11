local MODSTR = 'config.util'
local ERROR = vim.log.levels.ERROR
local validate = require('user_api.check').validate

---@class Config.Util
local M = {}
---@return boolean termguicolors
function M.has_tgc()
  if
    require('user_api.check').in_console()
    or not require('user_api.check.exists').vim_exists('+termguicolors')
  then
    return false
  end
  return vim.o.termguicolors
end

---@param cmd 'edit'|'tabnew'|'split'|'vsplit'
---@return function command
---@overload fun()
function M.key_variant(cmd)
  validate({ cmd = { cmd, { 'string', 'nil' }, true } })
  cmd = cmd or 'edit'
  cmd = vim.list_contains({ 'ed', 'edit', 'tabnew', 'split', 'vsplit' }, cmd) and cmd or 'edit'

  return function()
    vim.cmd[cmd](vim.fn.stdpath('config') .. '/lua/config/lazy.lua')
  end
end

---@return boolean has_luarocks
function M.luarocks_check()
  return require('user_api.check.exists').executable('luarocks')
    and require('user_api.check.exists').env_vars({ 'LUA_PATH', 'LUA_CPATH' })
end

---@param force boolean
---@overload fun()
function M.set_tgc(force)
  validate({ force = { force, { 'boolean', 'nil' }, true } })
  force = force ~= nil and force or false

  vim.o.termguicolors = not force
      and (require('user_api.check.exists').vim_exists('+termguicolors') and not require(
        'user_api.check'
      ).in_console())
    or true
end

---@param name string
---@param callback function
---@return function install_flag
---@overload fun(name: string): install_flag: function
function M.flag_installed(name, callback)
  validate({
    name = { name, { 'string' } },
    callback = { callback, { 'function', 'nil' }, true },
  })
  if name == '' then
    error(('(%s.flag_installed): Unable to set `vim.g` var'):format(MODSTR), ERROR)
  end

  local flag = (name:sub(1, 10) == 'installed_') and name or ('installed_' .. name)
  return function()
    vim.g[flag] = 1
    if callback and vim.is_callable(callback) then
      callback()
    end
  end
end

---A `config` function to call your plugin from a `lazy` spec.
--- ---
---@param mod_str string
---@return function
function M.require(mod_str)
  validate({ mod_str = { mod_str, { 'string' } } })

  return function()
    if require('user_api.check.exists').module(mod_str) then
      require(mod_str)
    end
  end
end

---Set the global condition for a later submodule call.
--- ---
---@param fields string|table<string, any>
---@param force_tgc boolean
---@return function init
---@overload fun(fields: string|table<string, any>): init: function
function M.colorscheme_init(fields, force_tgc)
  validate({
    fields = { fields, { 'string', 'table' } },
    force_tgc = { force_tgc, { 'boolean', 'nil' }, true },
  })
  force_tgc = force_tgc ~= nil and force_tgc or false

  return function()
    M.set_tgc(force_tgc)
    if require('user_api.check.value').is_str(fields) then
      M.flag_installed(fields)()
      return
    end
    for field, val in pairs(fields) do
      vim.g[field] = val
    end
  end
end

local CfgUtil = setmetatable(M, { ---@type Config.Util
  __index = M,
  __newindex = function()
    vim.notify('Config.Util is Read-Only!', ERROR)
  end,
})

return CfgUtil
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
