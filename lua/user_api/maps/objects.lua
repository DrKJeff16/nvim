---@class User.Maps.Opts: User.Maps.DescOpts, vim.keymap.set.Opts
---@field buffer? integer
local O = {}

---@enum (key) User.Maps.ValidOpts
local valid = {
  buf = 1,
  buffer = 1,
  callback = 1,
  desc = 1,
  expr = 1,
  noremap = 1,
  nowait = 1,
  remap = 1,
  replace_keycodes = 1,
  script = 1,
  silent = 1,
  unique = 1,
}

---@param T User.Maps.Opts|User.Maps.DescOpts
function O:add(T)
  require('user_api.check').validate({ T = { T, { 'table' } } })
  if vim.tbl_isempty(T) then
    return
  end

  for k, v in pairs(T) do
    if vim.list_contains(vim.tbl_keys(valid), k) then
      self[k] = v
    end
  end
end

O.__index = O

---@param T User.Maps.Opts|User.Maps.DescOpts
---@return User.Maps.Opts T
local function validate_opts(T)
  require('user_api.check').validate({ T = { T, { 'table', 'nil' }, true } })
  T = T or {}

  require('user_api.check').validate({
    ['T.buf'] = { T.buf, { 'number', 'nil' }, true },
    ['T.callback'] = { T.callback, { 'function', 'nil' }, true },
    ['T.desc'] = { T.desc, { 'string', 'nil' }, true },
    ['T.expr'] = { T.expr, { 'boolean', 'nil' }, true },
    ['T.noremap'] = { T.noremap, { 'boolean', 'nil' }, true },
    ['T.nowait'] = { T.nowait, { 'boolean', 'nil' }, true },
    ['T.remap'] = { T.remap, { 'boolean', 'nil' }, true },
    ['T.replace_keycodes'] = { T.replace_keycodes, { 'boolean', 'nil' }, true },
    ['T.script'] = { T.script, { 'boolean', 'nil' }, true },
    ['T.silent'] = { T.silent, { 'boolean', 'nil' }, true },
    ['T.unique'] = { T.unique, { 'boolean', 'nil' }, true },
  })
  T.desc = (T.desc and T.desc ~= '') and T.desc or 'Unnamed Key'
  if T.buf then
    T.buffer = T.buf
  end
  if T.expr == nil then
    T.expr = false
  end
  if T.noremap == nil then
    T.noremap = true
  end
  if T.nowait == nil then
    T.nowait = false
  end
  if T.remap == nil then
    T.remap = false
  end
  if T.replace_keycodes == nil then
    T.replace_keycodes = false
  end
  if T.script == nil then
    T.script = false
  end
  if T.silent == nil then
    T.silent = true
  end
  if T.unique == nil then
    T.unique = true
  end

  for k in pairs(T) do
    if not vim.list_contains(vim.tbl_keys(valid), k) then
      T[k] = nil
    end
  end

  return T
end

---@param T? User.Maps.Opts|User.Maps.DescOpts
---@return User.Maps.Opts new_object
function O.new(T)
  return setmetatable(validate_opts(T), O)
end

return O
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
