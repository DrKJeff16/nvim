---The Vim modes used for `which-key` as a `string`
---@alias RegModes 'n'|'i'|'v'|'t'|'o'|'x'

---This is an abstraction of `vim.keymaps.set.Opts` (see `User.Maps.Opts`),
---with few extensions.
---
---This table defines a keymap that is used for grouping keymaps with an extra sequence.
---
---This class type is reserved for either direct usage with `which-key`, or most regularly
---for `User.maps.map_dict()` and anything in the `User.maps.wk` module.
--- ---
---@class RegKey
--- AKA `lhs` of a Vim Keymap.
---
---@field [1] string
--- AKA `rhs` of a Vim Keymap.
---
---@field [2] string|function
---@field [3]? User.Maps.Opts
--- Keymap's description.
---
---@field desc? string
--- If `true`, `which-key` will hide this keymap
--- **See `:h vim.keymap.set()` to find the other fields**
---@field hidden? boolean
--- Any of the Vim modes: `'n'|'i'|'v'|'t'|'o'|'x'`
---@field mode? RegModes
---@field cond? boolean|fun(): boolean
---@field icon? string|wk.Icon|fun(): (wk.Icon|string)
---@field proxy? string
---@field expand? fun(): wk.Spec

--- A dictionary of string ==> `RegKey` class
---
---This merely describes a dictionary of `RegKey` type objects
---
---**Example:**
---
---```lua
----- DO NOT COPY THE CODE BELOW OUT OF THE BLUE!!!!
---
------@type RegKeys
---local Keys = {
---    ['<leader>x'] = {
---        rhs()|'rhs',
---        { ... }, ---@see vim.keymap.set.Opts
---        hidden = false,
---        mode = 'n' | 'i' | 'v' | 't' | 'o' | 'x',
---    },
---}
---```
--- ---
---@alias RegKeys table<string, RegKey>

---A dictionary of string ==> `RegPfx` class.
---
---This merely describes a dictionary of `RegPfx` type objects.
---
---**This is only valid if _`which-key`_ is installed.**
---
---@alias RegKeysNamed table<string, RegPfx>

---@alias ModeRegKeys table<MapModes, RegKeys>

---@alias ModeRegKeysNamed table<MapModes, RegKeysNamed>

---A group mapping scheme for usage related to `which-key`.
---
--- - **Warning:** If you remove the `group` field, it'll be parsed as any other table
---
---This class type is reserver for either direct usage with `which-key`, or most regularly
---for `User.maps.map_dict()` and anything in the `User.maps.wk` module.
---
---This table defines a keymap that is used for grouping keymaps with an extra sequence,
---for example:
---
---```
---<leader>fs    <=== [ ] not a group
---<leader>f     <=== [X] this is a group the keymap above belongs to
---```
---
---**_EXAMPLE:_**
---
---```lua
---arbitrory_keys = {
---    ['<leader><leader>']= { group = '+Group1', buffer = 4, hidden = true },
---}
---```
---
--- - `group` (`string`): The name of the group. Optionally you can prepend a `+` to the name,
---                   but I don't think `which-key` cares if you don't do it
---
--- - `hidden` (`boolean`, optional): Determines whether said key should be shown
---                               by `which-key` or not
---
---See `:h vim.keymap.set()` to find the other fields.
--- ---
---@class RegPfx: vim.keymap.set.Opts
---@field mode? MapModes
---@field proxy? string|fun(): string
---@field hidden? boolean
---@field group? string

---Configuration table to be passed to `require('which-key').add()`.
--- ---
---@class RegOpts: wk.Opts
---@field create? boolean
---@field notify? boolean
---@field version? number

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local O = require('user_api.maps.objects')
local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }
local in_list = vim.list_contains
local validate = require('user_api.check').validate

---`which_key` API entrypoints.
---@class User.Maps.WK
local WK = {}

---@return boolean
function WK.available()
  return require('user_api.check.exists').module('which-key')
end

---@param lhs string
---@param rhs string|function
---@param opts User.Maps.Opts|vim.keymap.set.Opts|wk.Spec
---@return wk.Spec converted
---@overload fun(lhs: string, rhs: string|function): converted: wk.Spec
function WK.convert(lhs, rhs, opts)
  validate({
    lhs = { lhs, { 'string' } },
    rhs = { rhs, { 'string', 'function' } },
    opts = { opts, { 'table', 'nil' }, true },
  })
  if not WK.available() then
    error('(user.maps.wk.convert): `which_key` not available', WARN)
  end
  local Value = require('user_api.check.value')
  opts = opts or {}

  local res = { lhs, rhs } ---@type wk.Spec
  if Value.is_bool(opts.hidden) then
    res.hidden = opts.hidden
    opts.hidden = nil
  end

  if Value.type_not_empty('string', opts.group) then
    res.proxy = opts.proxy
    opts.proxy = nil
  end

  if Value.type_not_empty('string', opts.group) then
    res.group = opts.group
    opts.group = nil
  end

  if Value.type_not_empty('string', opts.desc) then
    res.desc = opts.desc
    opts.desc = nil
  end

  return res
end

---@param T AllMaps
---@return AllMaps res
function WK.convert_dict(T)
  validate({ T = { T, { 'table' } } })

  local Value = require('user_api.check.value')
  local res = {} ---@type AllMaps
  for lhs, v in pairs(T) do
    local rhs = v[1] ---@type string|function
    local opts = Value.is_tbl(v[2]) and v[2] or {} ---@type User.Maps.Opts
    table.insert(res, WK.convert(lhs, rhs, opts))
  end
  return res
end

---@param T AllMaps
---@param opts User.Maps.Opts|wk.Spec
---@return false|nil
---@overload fun(T: AllMaps): false|nil
function WK.register(T, opts)
  validate({
    T = { T, { 'table' } },
    opts = { opts, { 'table', 'nil' }, true },
  })

  if not WK.available() then
    vim.notify('(user.maps.wk.register): `which_key` unavailable', ERROR)
    return false
  end

  local Value = require('user_api.check.value')
  opts = opts or O.new({ mode = 'n' })
  opts.mode = (Value.is_str(opts.mode) and in_list(MODES, opts.mode)) and opts.mode or 'n'

  local filtered = {} ---@type wk.Spec
  for _, val in pairs(T) do
    table.insert(filtered, val)
  end
  require('which-key').add(filtered)
end

local M = setmetatable(WK, { ---@type User.Maps.WK
  __index = WK,
  __newindex = function()
    vim.notify('User.Maps.WK is Read-Only!', ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
