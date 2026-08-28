local MODSTR = 'config.util'
local ERROR = vim.log.levels.ERROR
local validate = require('user_api').check.validate
local in_console = require('user_api').check.in_console
local executable = require('user_api').check.executable

---@class Config.Util
local M = {}

---@return boolean termguicolors
function M.has_tgc()
  if in_console() or not require('user_api').check.vim_exists('+termguicolors') then
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
    vim.cmd[cmd]({ args = { vim.fs.joinpath(vim.fn.stdpath('config'), 'lua/config/lazy.lua') } })
  end
end

---@return boolean has_luarocks
function M.luarocks_check()
  return executable('luarocks') and require('user_api').check.env_vars({ 'LUA_PATH', 'LUA_CPATH' })
end

---@param force? boolean
function M.set_tgc(force)
  validate({ force = { force, { 'boolean', 'nil' }, true } })
  if force == nil then
    force = false
  end

  vim.o.termguicolors = not force and (vim.fn.exists('+termguicolors') == 1 and not in_console()) or true
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
