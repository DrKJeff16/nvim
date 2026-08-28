---Non-legacy validation spec (>=v0.11)
---@class UserValidateSpec
---@field [1] any
---@field [2] vim.validate.Validator
---@field [3]? boolean
---@field [4]? string

---Exitstance checks.
---
---This contains many checkers for environment, modules, namespaces, etc.
---Also, simplified Vim functions can be found here.
--- ---
---@class User.Check.Existance
local M = {}

---Dynamic `vim.is_distro()` wrapper. Covers both legacy and newer implementations
---@param T table<string, vim.validate.Spec|UserValidateSpec>
function M.validate(T)
  local max = vim.fn.has('nvim-0.11') == 1 and 3 or 4
  for name, spec in pairs(T) do
    while #spec > max do
      table.remove(spec, #spec)
    end

    T[name] = spec
  end

  if max == 3 then
    ---@cast T table<string, UserValidateSpec>
    for name, spec in pairs(T) do
      table.insert(spec, 1, name)
      vim.validate(unpack(spec))
    end
  else
    ---@cast T table<string, vim.validate.Spec>
    vim.validate(T)
  end
end

---@param mod string[]|string
---@return boolean exists
function M.module(mod)
  M.validate({ mod = { mod, { 'string', 'table' } } })

  if type(mod) == 'string' then
    return (pcall(require, mod))
  end

  for i, v in ipairs(mod) do
    M.validate({ ['mod_' .. i] = { v, { 'string' } } })
    if not M.module(v) then
      return false
    end
  end
  return true
end

---@param expr string[]|string
---@return boolean has
function M.vim_has(expr)
  M.validate({ expr = { expr, { 'string', 'table' } } })

  if type(expr) == 'string' then
    return vim.fn.has(expr) == 1
  end

  for i, v in ipairs(expr) do
    M.validate({ ['expr_' .. i] = { v, { 'string' } } })
    if not M.vim_has(v) then
      return false
    end
  end
  return true
end

---@param expr string[]|string
---@return boolean exists
function M.vim_exists(expr)
  M.validate({ expr = { expr, { 'string', 'table' } } })

  if type(expr) == 'string' then
    return vim.fn.exists(expr) == 1
  end

  for i, v in ipairs(expr) do
    M.validate({ ['expr_' .. i] = { v, { 'string' } } })
    if not M.vim_exists(v) then
      return false
    end
  end
  return true
end

---@param vars string[]|string
---@param callback? function
---@return boolean found
function M.env_vars(vars, callback)
  M.validate({
    vars = { vars, { 'string', 'table' } },
    callback = { callback, { 'function', 'nil' }, true },
  })

  local environment = vim.fn.environ()
  local res = false

  if type(vars) == 'string' then
    res = vim.fn.has_key(environment, vars) == 1
  else
    for _, v in ipairs(vars) do
      res = M.env_vars(v)
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
function M.executable(exe)
  M.validate({ exe = { exe, { 'string', 'table' } } })

  if type(exe) == 'string' then
    return vim.fn.executable(exe) == 1
  end

  local res = false
  for i, v in ipairs(exe) do
    M.validate({ ['exe.' .. i] = { v, { 'string' } } })
    res = M.executable(v)
    if not res then
      break
    end
  end
  return res
end

---@param path string
---@return boolean is_dir
function M.vim_isdir(path)
  M.validate({ path = { path, { 'string' } } })

  return vim.fn.isdirectory(path) == 1
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
