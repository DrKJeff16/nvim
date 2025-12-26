local uv = vim.uv or vim.loop

---Checking Utilities.
--- ---
---@class User.Check
local Check = {
  value = require('user_api.check.value'),
  exists = require('user_api.check.exists'),
  ---Check whether Neovim is running as root (`PID == 0`).
  --- ---
  is_root = function()
    return uv.getuid() == 0
  end,
  ---Check whether Neovim is running in a Windows environment.
  --- ---
  is_windows = function()
    return vim.fn.has('win32') == 1
  end,
}

---Check whether Nvim is running in a Linux Console rather than a `pty`.
---
---This function can be useful for (un)loading certain elements
---that conflict with the Linux console, for example.
--- ---
function Check.in_console()
  --- FIXME: This is not a good enough check. Must find a better solution
  local env = vim.fn.environ() ---@type table<string, string>
  return vim.list_contains({ 'linux' }, env.TERM) and not Check.value.fields('DISPLAY', env)
end

local M = setmetatable(Check, { ---@type User.Check
  __index = Check,
  __newindex = function()
    vim.notify('User.Check is Read-Only!', vim.log.levels.ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
