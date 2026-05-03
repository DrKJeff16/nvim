---@meta
--# selene: allow(unused_variable)
-- luacheck: ignore

---@module 'user_api.maps.wk'
---@module 'user_api.maps.keymap'

---@class User.Maps
local Maps = {
  modes = { 'n', 'i', 'v', 't', 'o', 'x' },
  wk = {}, ---@type User.Maps.WK
  keymap = {}, ---@type User.Maps.Keymap|table<MapModes, fun(lhs: string, rhs: string|function, opts?: vim.keymap.set.Opts)>
}

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
function Maps.new_desc(desc, opts) end

---@deprecated Use `new_desc()` instead
---@param desc string
---@param silent? boolean
---@param bufnr? integer|nil
---@param noremap? boolean
---@param nowait? boolean
---@param expr? boolean
---@return User.Maps.Opts opts
function Maps.desc(desc, silent, bufnr, noremap, nowait, expr) end

---@param T AllMaps
---@param map_func 'keymap'|'wk.register'
function Maps.map_dict(T, map_func) end

---@param T AllMaps
---@param map_func 'keymap'|'wk.register'
---@param has_modes true
function Maps.map_dict(T, map_func, has_modes) end

---@param T AllMaps
---@param map_func 'keymap'|'wk.register'
---@param has_modes false
---@param mode (MapModes)[]|MapModes
function Maps.map_dict(T, map_func, has_modes, mode) end

---@param T AllMaps
---@param map_func 'keymap'|'wk.register'
---@param has_modes true
---@param mode nil
---@param bufnr integer
function Maps.map_dict(T, map_func, has_modes, mode, bufnr) end

---@param T AllModeMaps
---@param map_func 'keymap'|'wk.register'
---@param has_modes false
---@param mode (MapModes)[]|MapModes
---@param bufnr integer
function Maps.map_dict(T, map_func, has_modes, mode, bufnr) end

---@param T string[]|string
function Maps.nop(T) end

---@param T string[]|string
---@param opts User.Maps.Opts
function Maps.nop(T, opts) end

---@param T string[]|string
---@param opts User.Maps.Opts
---@param mode MapModes
function Maps.nop(T, opts, mode) end

---@param T string[]|string
---@param opts User.Maps.Opts
---@param mode MapModes|nil
---@param prefix string
function Maps.nop(T, opts, mode, prefix) end
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
