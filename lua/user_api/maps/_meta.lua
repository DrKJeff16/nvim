---@meta
--# selene: allow(unused_variable)
-- luacheck: ignore

---@module 'user_api.maps.wk'
---@module 'user_api.maps.keymap'

---@class User.Maps
---@field keymap User.Maps.Keymap
---@field modes Modes
---@field objects User.Maps.Opts
---@field wk User.Maps.WK
local Maps = {}

---@class User.Maps.DescOpts
---@field buf? integer
---@field callback? function
---@field desc? string
---@field expr? boolean
---@field noremap? boolean
---@field nowait? boolean
---@field remap? boolean
---@field replace_keycodes? boolean
---@field script? boolean
---@field silent? boolean
---@field unique? boolean

---@param desc? string
---@param opts? User.Maps.DescOpts
---@return User.Maps.Opts opts
function Maps.desc(desc, opts) end

---@overload fun(T: AllMaps, map_func: 'keymap'|'wk.register')
---@overload fun(T: AllMaps, map_func: 'keymap'|'wk.register', has_modes: true)
---@overload fun(T: AllMaps, map_func: 'keymap'|'wk.register', has_modes: false, mode: (MapModes)[]|MapModes)
---@overload fun(T: AllMaps, map_func: 'keymap'|'wk.register', has_modes: true, mode: nil, bufnr: integer)
---@overload fun(T: AllMaps, map_func: 'keymap'|'wk.register', has_modes: false, mode: (MapModes)[]|MapModes, bufnr: integer)
function Maps.map_dict(T, map_func) end

---@overload fun(T: string[]|string)
---@overload fun(T: string[]|string, opts: User.Maps.Opts)
---@overload fun(T: string[]|string, opts: User.Maps.Opts, mode: MapModes)
---@overload fun(T: string[]|string, opts: User.Maps.Opts, mode?: MapModes, prefix: string)
function Maps.nop(T) end
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
