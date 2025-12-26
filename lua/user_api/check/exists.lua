local MODSTR = 'user_api.check.exists'
local ERROR = vim.log.levels.ERROR

---@return User.Check.Value value
local function get_value()
  return require('user_api.check.value')
end

---Exitstance checks.
---
---This contains many checkers for environment, modules, namespaces, etc.
---Also, simplified Vim functions can be found here.
--- ---
---@class User.Check.Existance
local Exists = {}

---@param mod string
---@return boolean exists
function Exists.module(mod)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('mod', mod, 'string', false)
  else
    vim.validate({ mod = { mod, { 'string' } } })
  end

  if not get_value().type_not_empty('string', mod) then
    error(('`(%s.module)`: Input is not valid'):format(MODSTR), ERROR)
  end

  local res = pcall(require, mod)
  return res
end

---@param expr string[]|string
---@return boolean has
function Exists.vim_has(expr)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('expr', expr, { 'string', 'table' }, false, 'string[]|string')
  else
    vim.validate({ expr = { expr, { 'string', 'table' } } })
  end

  ---@cast expr string
  if get_value().type_not_empty('string', expr) then
    return vim.fn.has(expr) == 1
  end

  ---@cast expr string[]
  for _, v in ipairs(expr) do
    if not Exists.vim_has(v) then
      return false
    end
  end
  return true
end

---@param expr string[]|string
---@return boolean exists
function Exists.vim_exists(expr)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('expr', expr, { 'string', 'table' }, false, 'string[]|string')
  else
    vim.validate({ expr = { expr, { 'string', 'table' } } })
  end
  ---@cast expr string
  if get_value().type_not_empty('string', expr) then
    return vim.fn.exists(expr) == 1
  end

  local res = false

  ---@cast expr string[]
  for _, v in ipairs(expr) do
    res = Exists.vim_exists(v)
    if not res then
      break
    end
  end
  return res
end

---@param vars string[]|string
---@param callback function|nil
---@return boolean found
function Exists.env_vars(vars, callback)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('vars', vars, { 'string', 'table' }, false, 'string[]|string')
    vim.validate('callback', callback, 'function', true)
  else
    vim.validate({
      vars = { vars, { 'string', 'table' } },
      callback = { callback, { 'function', 'nil' }, true },
    })
  end

  local environment = vim.fn.environ()
  local res = false

  ---@cast vars string
  if get_value().is_str(vars) then
    res = vim.fn.has_key(environment, vars) == 1
  elseif get_value().is_tbl(vars) then
    ---@cast vars string[]
    for _, v in ipairs(vars) do
      res = Exists.env_vars(v)
      if not res then
        break
      end
    end
  end
  if not res and callback and vim.is_callable(callback) then
    callback()
  end
  return res
end

---@param exe string[]|string
---@return boolean found
function Exists.executable(exe)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('exe', exe, { 'string', 'table' }, false, 'string[]|string')
  else
    vim.validate({ exe = { exe, { 'string', 'table' } } })
  end

  local res = false

  ---@cast exe string
  if get_value().is_str(exe) then
    res = vim.fn.executable(exe) == 1
  elseif get_value().is_tbl(exe) then
    ---@cast exe string[]
    for _, v in ipairs(exe) do
      res = Exists.executable(v)
      if not res then
        break
      end
    end
  end
  return res
end

---@param path string
---@return boolean is_dir
function Exists.vim_isdir(path)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('path', path, 'string', false)
  else
    vim.validate({ path = { path, { 'string' } } })
  end
  return get_value().type_not_empty('string', path) and (vim.fn.isdirectory(path) == 1) or false
end

local M = setmetatable(Exists, { ---@type User.Check.Existance
  __index = Exists,
  __newindex = function()
    vim.notify('User.Check.Exists table is Read-Only!', ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
