---Available modes.
--- ---
---@alias MapModes 'n'|'i'|'v'|'t'|'o'|'x'

---Array for available modes.
--- ---
---@alias Modes (MapModes)[]

---@class KeyMapRhsArr
---@field [1] string|function
---@field [2]? User.Maps.Opts

---@class KeyMapRhsDict
---@field rhs string|function
---@field opts? User.Maps.Opts

---Array for `vim.keymap.set` arguments.
--- ---
---@class KeyMapArr
---@field [1] string
---@field [2] string|function
---@field [3]? User.Maps.Opts

---@alias KeyMapDict table<string, KeyMapRhsArr>
---@alias KeyMapDicts table<string, KeyMapRhsDict>

---@alias AllMaps table<string, KeyMapRhsArr|RegKey|RegPfx>
---@alias AllModeMaps table<MapModes, AllMaps>

---@class KeyMapTbl
---@field lhs string
---@field rhs string|function
---@field opts? User.Maps.Opts

---@class KeyMapModeDict
---@field n KeyMapDict
---@field i KeyMapDict
---@field v KeyMapDict
---@field t KeyMapDict
---@field o KeyMapDict
---@field x KeyMapDict

---@class KeyMapModeDicts
---@field n KeyMapTbl[]
---@field i KeyMapTbl[]
---@field v KeyMapTbl[]
---@field t KeyMapTbl[]
---@field o KeyMapTbl[]
---@field x KeyMapTbl[]

local ERROR = vim.log.levels.ERROR

---@param mode MapModes
---@return fun(lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts)
local function variant(mode)
    ---@param lhs string
    ---@param rhs string|function
    ---@param opts? vim.keymap.set.Opts
    return function(lhs, rhs, opts)
        if vim.fn.has('nvim-0.11') == 1 then
            vim.validate('lhs', lhs, { 'string' }, false)
            vim.validate('rhs', rhs, { 'string', 'function' }, false)
            vim.validate('opts', opts, { 'table', 'nil' }, true, 'vim.keymap.set.Opts')
        else
            vim.validate({
                lhs = { lhs, { 'string' } },
                rhs = { rhs, { 'string', 'function' } },
                opts = { opts, { 'table', 'nil' }, true },
            })
        end

        vim.keymap.set(mode, lhs, rhs, opts or {})
    end
end

---@class User.Maps.Keymap
local Keymap = {
    n = variant('n'),
    i = variant('i'),
    v = variant('v'),
    t = variant('t'),
    o = variant('o'),
    x = variant('x'),
}

local M = setmetatable({}, { ---@type User.Maps.Keymap
    __index = Keymap,
    __newindex = function()
        vim.notify('User.Maps.Keymap is Read-Only!', ERROR)
    end,
})

return M
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
