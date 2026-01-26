---@class User.Maps.Opts: vim.keymap.set.Opts
local O = {}

local valid = {
  'buffer',
  'callback',
  'desc',
  'expr',
  'noremap',
  'nowait',
  'remap',
  'replace_keycodes',
  'script',
  'silent',
  'unique',
}

---@param T User.Maps.Opts
function O:add(T)
  require('user_api.check.exists').validate({ T = { T, { 'table' } } })
  if vim.tbl_isempty(T) then
    return
  end

  for k, v in pairs(T) do
    if vim.list_contains(valid, k) then
      self[k] = v
    end
  end
end

---@param T User.Maps.Opts
---@return User.Maps.Opts new_object
---@overload fun()
function O.new(T)
  require('user_api.check.exists').validate({ T = { T, { 'table', 'nil' }, true } })

  return setmetatable(T or {}, { __index = O })
end

return O
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
