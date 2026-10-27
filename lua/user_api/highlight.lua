---@alias HlDict table<string, vim.api.keyset.highlight>
---@alias HlPair { name: string, opts: vim.api.keyset.highlight }

local validate = require('user_api.check').validate

---A set of utilities to make Vim highlighting easier.
--- ---
---@class User.Hl
local M = {}

---@param name string The highlight group
---@param opts vim.api.keyset.highlight The highlight options
---@param ns integer The highlighting namespace
---@overload fun(name: string, opts: vim.api.keyset.highlight)
function M.hl(name, opts, ns)
  validate({
    name = { name, { 'string' } },
    opts = { opts, { 'table' } },
    ns = { ns, { 'number', 'nil' }, true },
  })

  vim.api.nvim_set_hl(ns or 0, name, opts)
end

---Set highlight groups based on an array of `HlPair` type highlight groups.
--- ---
---Example of a valid `HlPair` array:
---```lua
---local T = { ---@type HlPair[]
---  { name = 'HlGroup', opts = { fg = '...', ... } } ,
---  { name = 'HlGroupAlt', opts = { link = 'Normal' },
---  --- ...
---}
---```
---See more at `:h nvim_set_hl`.
--- ---
---@param A HlPair[] The array of `HlPair` objects
---@param ns integer
---@overload fun(A: HlPair[])
function M.hl_from_arr(A, ns)
  validate({
    A = { A, { 'table' } },
    ns = { ns, { 'number', 'nil' }, true },
  })

  for _, t in ipairs(A) do
    validate({
      t = { t, { 'table' } },
      ['t.name'] = { t.name, { 'string' } },
      ['t.opts'] = { t.opts, { 'table' } },
    })

    M.hl(t.name, t.opts, ns or nil)
  end
end

---Set highlight groups using a `HlDict` type table.
--- ---
---Example of a valid `HlDict` table:
---```lua
---local T = { ---@type HlDict
---  HlGroup = { fg = '...' },
---  HlGroupAlt = { link = 'Normal' },
---}
---```
---To know what options are valid try `:h nvim_set_hl`.
--- ---
---@param D HlDict
---@param ns integer
---@overload fun(D: HlDict)
function M.hl_from_dict(D, ns)
  validate({
    D = { D, { 'table' } },
    ns = { ns, { 'number', 'nil' }, true },
  })

  for k, v in pairs(D) do
    validate({
      k = { k, { 'string' } },
      v = { v, { 'table' } },
    })

    M.hl(k, v, ns or nil)
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
