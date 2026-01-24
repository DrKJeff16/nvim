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

---@return User.Maps.Opts res
function Maps.desc() end

---@param desc string|nil
---@return User.Maps.Opts res
function Maps.desc(desc) end

---@param desc string|nil
---@param silent boolean|nil
---@return User.Maps.Opts res
function Maps.desc(desc, silent) end

---@param desc string|nil
---@param silent boolean|nil
---@param bufnr integer|nil
---@return User.Maps.Opts res
function Maps.desc(desc, silent, bufnr) end

---@param desc string|nil
---@param silent boolean|nil
---@param bufnr integer|nil
---@param noremap boolean|nil
---@return User.Maps.Opts res
function Maps.desc(desc, silent, bufnr, noremap) end

---@param desc string|nil
---@param silent boolean|nil
---@param bufnr integer|nil
---@param noremap boolean|nil
---@param nowait boolean|nil
---@return User.Maps.Opts res
function Maps.desc(desc, silent, bufnr, noremap, nowait) end

---@param desc string|nil
---@param silent boolean|nil
---@param bufnr integer|nil
---@param noremap boolean|nil
---@param nowait boolean|nil
---@param expr boolean|nil
---@return User.Maps.Opts res
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
