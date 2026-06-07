local uv = vim.uv or vim.loop
local validate = require('user_api.check.exists').validate

---@param path string
---@param mod? string
---@return string stripped
local function strip_slash(path, mod)
  validate({
    path = { path, { 'string' } },
    mod = { mod, { 'string', 'nil' }, true },
  })
  mod = mod or ':p'

  path = vim.fn.fnamemodify(path, mod)
  while vim.startswith(path:reverse(), '/') do
    path = path:sub(1, path:len() - 1)
  end
  return path
end

---Checking Utilities.
--- ---
---@class User.Check: User.Check.Value, User.Check.Existance
---@field exists User.Check.Existance
---@field value User.Check.Value
local M = {}

---Check whether Neovim is running as root (`PID == 0`).
--- ---
---@return boolean is_root
function M.is_root()
  return uv.getuid() == 0
end

---Check whether Neovim is running in a Windows environment.
--- ---
---@return boolean is_windows
function M.is_windows()
  return vim.fn.has('win32') == 1
end

---@param path string
---@return boolean absolute
function M.is_absolute(path)
  validate({ path = { path, { 'string' } } })

  return vim.list_contains(
    { strip_slash(path, ':p:~'), strip_slash(path), vim.fn.fnamemodify(path, ':p'), vim.fn.fnamemodify(path, ':p:~') },
    path
  )
end

---Check whether Nvim is running in a Linux Console rather than a `pty`.
---
---This function can be useful for (un)loading certain elements
---that conflict with the Linux console, for example.
--- ---
---@return boolean in_console
function M.in_console()
  --- FIXME: This is not a good enough check. Must find a better solution
  local env = vim.fn.environ() ---@type table<string, string>
  return vim.list_contains({ 'linux' }, env.TERM) and not require('user_api.check.value').fields('DISPLAY', env)
end

local Check = setmetatable(M, { ---@type User.Check
  ---@param self User.Check
  ---@param k integer|string
  __index = function(self, k)
    if require('user_api.check.exists').module('user_api.check.' .. k) then
      return require('user_api.check.' .. k)
    end
    if require('user_api.check.value')[k] then
      return require('user_api.check.value')[k]
    end
    if require('user_api.check.exists')[k] then
      return require('user_api.check.exists')[k]
    end
    return rawget(self, k) or nil
  end,
})

return Check
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
