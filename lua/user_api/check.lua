local ERROR = vim.log.levels.ERROR
local uv = vim.uv or vim.loop

---Checking Utilities.
--- ---
---@class User.Check
local Check = {
    value = require('user_api.check.value'),
    exists = require('user_api.check.exists'),
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

---Check whether Nvim is running as root (`PID == 0`).
--- ---
function Check.is_root()
    return uv.getuid() == 0
end

local M = setmetatable(Check, { ---@type User.Check
    __index = Check,
    __newindex = function(_, _, _)
        vim.notify('User.Check is read-only!', ERROR)
    end,
})
return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
