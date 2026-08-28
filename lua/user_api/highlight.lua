---@alias HlDict table<string, vim.api.keyset.highlight>

---@class HlPair
---@field name string
---@field opts vim.api.keyset.highlight

---A set of utilities to make Vim highlighting easier.
--- ---
---@class User.Hl
local M = {}

---@param name string The highlight group
---@param opts vim.api.keyset.highlight The highlight options
---@param ns? integer The highlighting namespace
function M.hl(name, opts, ns)
  require('user_api.check').validate({
    name = { name, { 'string' } },
    opts = { opts, { 'table' } },
    ns = { ns, { 'number', 'nil' }, true },
  })

  if name and opts and type(name) == 'string' and type(opts) == 'table' then
    vim.api.nvim_set_hl(ns or 0, name, opts)
  end
end

---Set highlight groups based on an array of `HlPair` type highlight groups.
--- ---
---Example of a valid `HlPair` array:
---```lua
------@type HlPair[]
---local T = {
---  { name = 'HlGroup', opts = { fg = '...', ... } } ,
---  { name = 'HlGroupAlt', opts = { link = 'Normal' },
---  --- ...
---}
---```
---See more at `:h nvim_set_hl`.
--- ---
---@param A HlPair[] The array of `HlPair` objects
---@param ns? integer
function M.hl_from_arr(A, ns)
  require('user_api.check').validate({
    A = { A, { 'table' } },
    ns = { ns, { 'number', 'nil' }, true },
  })

  local type_not_empty = require('user_api.check').type_not_empty
  for _, t in ipairs(A) do
    if type_not_empty('string', t.name) and type_not_empty('table', t.opts) then
      M.hl(t.name, t.opts, ns or nil)
    end
  end
end

---Set highlight groups using a `HlDict` type table.
--- ---
---Example of a valid `HlDict` table:
---```lua
------@type HlDict
---local T = {
---  HlGroup = { fg = '...' },
---  HlGroupAlt = { link = 'Normal' },
---}
---```
---To know what options are valid try `:h nvim_set_hl`.
--- ---
---@param D HlDict
---@param ns? integer
function M.hl_from_dict(D, ns)
  require('user_api.check').validate({
    D = { D, { 'table' } },
    ns = { ns, { 'number', 'nil' }, true },
  })

  local type_not_empty = require('user_api.check').type_not_empty
  for k, v in pairs(D) do
    if type_not_empty('string', k) and type_not_empty('table', v) then
      M.hl(k, v, ns or nil)
    end
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
