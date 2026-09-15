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
---@field cond? boolean|fun(): cond: boolean
---@field expand? fun(): spec: wk.Spec
--- If `true`, `which-key` will hide this keymap
--- **See `:h vim.keymap.set()` to find the other fields**
---@field hidden? boolean
---@field icon? string|wk.Icon|fun(): icon: wk.Icon|string
--- Any of the Vim modes: `'n'`, `'i'`, `'v'`, `'t'`, `'o'`, `'x'`, `'V'`
---@field mode? RegModes
---@field proxy? string

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
---arbitrary_keys = {
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
---@field group? string
---@field hidden? boolean
---@field mode? MapModes
---@field proxy? string|fun(): proxy: string

---Configuration table to be passed to `require('which-key').add()`.
--- ---
---@class RegOpts: wk.Opts
---@field create? boolean
---@field notify? boolean
---@field version? number

local MODES = { 'V', 'i', 'n', 'o', 't', 'v', 'x' }
local validate = require('user_api.check').validate

---`which_key` API entrypoints.
---@class User.Maps.WK
local M = {}

---@return boolean
function M.available()
  return require('user_api.check').module('which-key')
end

---@param lhs string
---@param rhs string|function
---@param opts? User.Maps.Opts|vim.keymap.set.Opts|wk.Spec
---@return wk.Spec converted
function M.convert(lhs, rhs, opts)
  validate({
    lhs = { lhs, { 'string' } },
    rhs = { rhs, { 'string', 'function' } },
    opts = { opts, { 'table', 'nil' }, true },
  })
  if not M.available() then
    error('(user.maps.wk.convert): `which_key` not available', vim.log.levels.WARN)
  end
  opts = opts or {}

  local res = { lhs, rhs } ---@type wk.Spec
  if type(opts.hidden) == 'boolean' then
    res.hidden = opts.hidden
    opts.hidden = nil
  end
  if type(opts.proxy) == 'string' then
    res.proxy = opts.proxy
    opts.proxy = nil
  end
  if type(opts.group) == 'string' then
    res.group = opts.group
    opts.group = nil
  end
  if type(opts.desc) == 'string' then
    res.desc = opts.desc
    opts.desc = nil
  end
  return res
end

---@param T AllMaps
---@return AllMaps res
function M.convert_dict(T)
  validate({ T = { T, { 'table' } } })

  local res = {} ---@type AllMaps
  for lhs, v in pairs(T) do
    table.insert(res, M.convert(lhs, v[1], v[2] or {}))
  end
  return res
end

---@param T AllMaps
---@param opts? User.Maps.Opts|wk.Spec
---@return false|nil|? success
function M.register(T, opts)
  validate({
    T = { T, { 'table' } },
    opts = { opts, { 'table', 'nil' }, true },
  })

  if not M.available() then
    vim.notify('(user.maps.wk.register): `which_key` unavailable', vim.log.levels.ERROR)
    return false
  end

  opts = opts or require('user_api.maps.objects').new({ mode = 'n' })
  opts.mode = (opts.mode and type(opts.mode) == 'string' and vim.list_contains(MODES, opts.mode)) and opts.mode or 'n'

  local filtered = {} ---@type wk.Spec
  for _, val in pairs(T) do
    table.insert(filtered, val)
  end
  require('which-key').add(filtered)
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
