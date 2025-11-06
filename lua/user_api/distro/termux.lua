--- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Termux packages)

local function is_dir(dir)
    return vim.fn.isdirectory(dir) == 1
end

local ERROR = vim.log.levels.ERROR
local environ = vim.fn.environ
local copy = vim.deepcopy

---@class User.Distro.Termux
local Termux = {}

Termux.PREFIX = vim.fn.has_key(environ(), 'PREFIX') and environ().PREFIX or '' ---@type string|''
Termux.rtpaths = {
    ('%s/share/vim/vimfiles/after'):format(Termux.PREFIX),
    ('%s/share/vim/vimfiles'):format(Termux.PREFIX),
    ('%s/share/nvim/runtime'):format(Termux.PREFIX),
    ('%s/local/share/vim/vimfiles/after'):format(Termux.PREFIX),
    ('%s/local/share/vim/vimfiles'):format(Termux.PREFIX),
    ('%s/local/share/nvim/runtime'):format(Termux.PREFIX),
}

function Termux.validate()
    if Termux.PREFIX == '' or not is_dir(Termux.PREFIX) then
        return false
    end

    local new_rtpaths = {} ---@type string[]
    for _, path in ipairs(Termux.rtpaths) do
        if is_dir(path) then
            table.insert(new_rtpaths, path)
        end
    end
    if require('user_api.check.value').empty(new_rtpaths) then
        return false
    end

    Termux.rtpaths = copy(new_rtpaths)
    return true
end

---@type User.Distro.Termux|fun()
local M = setmetatable({}, {
    __index = Termux,
    __newindex = function(_, _, _)
        error('User.Distro.Termux is Read-Only!', ERROR)
    end,
    __call = function(self) ---@param self User.Distro.Termux
        if not (Termux.validate() and is_dir(Termux.PREFIX)) then
            return
        end
        for _, path in ipairs(self.rtpaths) do
            if is_dir(path) == 1 then
                vim.go.rtp = vim.go.rtp .. ',' .. path
            end
        end
        vim.api.nvim_set_option_value('wrap', true, { scope = 'global' })
    end,
})

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
