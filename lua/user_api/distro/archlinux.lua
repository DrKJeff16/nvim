---Modify runtimepath to also search the system-wide Vim directory
---(e.g. for Vim runtime files from Arch Linux packages)

local ERROR = vim.log.levels.ERROR
local in_list = vim.list_contains

local function is_dir(dir) ---@param dir string
    return vim.fn.isdirectory(dir) == 1
end

---@class User.Distro.Archlinux
local Archlinux = {}

local RTPATHS = { ---@type string[]
    '/usr/share/vim/vimfiles/after',
    '/usr/share/vim/vimfiles',
    '/usr/share/nvim/runtime',
    '/usr/local/share/vim/vimfiles/after',
    '/usr/local/share/vim/vimfiles',
    '/usr/local/share/nvim/runtime',
}

Archlinux.rtpaths = setmetatable(RTPATHS, { ---@type string[]
    __index = RTPATHS,
    __newindex = function()
        vim.notify('User.Distro.Archlinux.rtpaths is Read-Only!', ERROR)
    end,
})

function Archlinux.validate()
    -- First check for each dir's existance
    local new_rtpaths = {} ---@type string[]
    for _, p in ipairs(Archlinux.rtpaths) do
        if vim.fn.isdirectory(p) == 1 and not in_list(new_rtpaths, p) then
            table.insert(new_rtpaths, p)
        end
    end

    -- If no dirs...
    if not require('user_api.check.value').type_not_empty('table', new_rtpaths) then
        return false
    end

    Archlinux.rtpaths = vim.deepcopy(new_rtpaths)
    return true
end

local M = setmetatable({}, { ---@type User.Distro.Archlinux|function
    __index = Archlinux,
    __newindex = function()
        vim.notify('User.Distro.Archlinux is Read-Only!', ERROR)
    end,
    __call = function(self) ---@param self User.Distro.Archlinux
        if not self.validate() then
            return
        end
        for _, path in ipairs(self.rtpaths) do
            if is_dir(path) then
                vim.o.runtimepath = vim.o.runtimepath .. ',' .. path
            end
        end
        pcall(vim.cmd.runtime, { 'archlinux.vim', bang = true })
    end,
})

return M
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
