local MODSTR = 'config.util'
local ERROR = vim.log.levels.ERROR
local validate = require('user_api.check').validate
local in_console = require('user_api.check').in_console
local executable = require('user_api.check').executable

---@class Config.Util
local M = {}

---@return boolean termguicolors
function M.has_tgc()
  if in_console() or not require('user_api.check.exists').vim_exists('+termguicolors') then
    return false
  end
  return vim.o.termguicolors
end

---@param cmd? 'edit'|'tabnew'|'split'|'vsplit'
---@return function command
function M.key_variant(cmd)
  validate({ cmd = { cmd, { 'string', 'nil' }, true } })
  cmd = (cmd and vim.list_contains({ 'edit', 'tabnew', 'split', 'vsplit' }, cmd)) and cmd or 'edit'

  return function()
    vim.cmd[cmd](vim.fs.joinpath(vim.fn.stdpath('config'), 'lua/config/lazy.lua'))
  end
end

---@return boolean has_luarocks
function M.luarocks_check()
  return executable('luarocks') and require('user_api.check').env_vars({ 'LUA_PATH', 'LUA_CPATH' })
end

---@param force? boolean
function M.set_tgc(force)
  validate({ force = { force, { 'boolean', 'nil' }, true } })
  force = force ~= nil and force or false

  vim.o.termguicolors = not force and (vim.fn.exists('+termguicolors') == 1 and not in_console())
    or true
end

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
    if not (callback and vim.is_callable(callback)) then
      return
    end
    callback()
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

local CfgUtil = setmetatable(M, { ---@type Config.Util
  __index = M,
  __newindex = function()
    vim.notify('Config.Util is Read-Only!', ERROR)
  end,
})

return CfgUtil
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
