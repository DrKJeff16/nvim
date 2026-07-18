---@module 'which-key'

---Available modes.
--- ---
---@alias MapModes 'n'|'i'|'v'|'t'|'o'|'x'|'V'

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

---@class AllModeMaps
---@field n? AllMaps
---@field i? AllMaps
---@field v? AllMaps
---@field t? AllMaps
---@field o? AllMaps
---@field V? AllMaps
---@field x? AllMaps

---@class KeyMapTbl
---@field lhs string
---@field rhs string|function
---@field opts? User.Maps.Opts

---@alias KeyMapModeDict table<'n'|'i'|'v'|'t'|'o'|'x'|'V', KeyMapDict>
---@alias KeyMapModeDicts table<'n'|'i'|'v'|'t'|'o'|'x'|'V', KeyMapTbl[]>

---@param mode MapModes
---@return fun(lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts)
local function variant(mode)
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts? vim.keymap.set.Opts
  return function(lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts or {})
  end
end

---@class User.Maps.Keymap
local M = {}

M.V = variant('V')
M.i = variant('i')
M.n = variant('n')
M.o = variant('o')
M.t = variant('t')
M.v = variant('v')
M.x = variant('x')

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
