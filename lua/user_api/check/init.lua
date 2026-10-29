local Util = require('user_api.util')

---@generic T: table, F
---@param t T
---@param k any
---@param fallback F
---@return F fallback
local function get(t, k, fallback)
  return Util.get(t, k, function()
    return Util.rawset(t, k, fallback)
  end, true)
end

---@param path string
---@param mod string
---@return string stripped
---@overload fun(path: string): stripped: string
local function strip_slash(path, mod)
  require('user_api.check.exists').validate({
    path = { path, { 'string' } },
    mod = { mod, { 'string', 'nil' }, true },
  })

  path = vim.fn.fnamemodify(path, mod or ':p')
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

setmetatable(M, {
  __index = function(self, k) ---@param self User.Check
    local raw = Util.get(self, k)
    if raw ~= nil then
      return raw
    end

    if type(k) ~= 'string' then
      return
    end

    if require('user_api.check.exists').module('user_api.check.' .. k) then
      return get(self, k, require('user_api.check.' .. k))
    end
    if self.value[k] then
      return get(self, k, self.value[k])
    end
    if self.exists[k] then
      return get(self, k, self.exists[k])
    end
    require('user_api.backtrace')(vim.log.levels.ERROR, ('Invalid key: `%s`'):format(k))
  end,
})

---Check whether Neovim is running as root (`PID == 0`).
--- ---
---@return boolean is_root
function M.is_root()
  return (vim.uv or vim.loop).getuid() == 0
end

---Check whether Neovim is running in a Windows environment.
--- ---
---@return boolean is_windows
function M.is_windows()
  return M.exists.vim_has('win32')
end

---@param path string
---@return boolean absolute
function M.is_absolute(path)
  M.exists.validate({ path = { path, { 'string' } } })

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
  local env = vim.fn.environ() --[[@as table<string, string>]]
  -- FIXME: This is not a good enough check. Must find a better solution
  return vim.list_contains({ 'linux' }, env['TERM']) and not M.value.fields('DISPLAY', env)
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
