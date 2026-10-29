---@alias Types 'string'|'number'|'function'|'boolean'|'table'
---@alias EmptyTypes 'string'|'number'|'integer'|'table'

local validate = require('user_api.check.exists').validate

---@param t Types
---@return (fun(var: any): res: boolean)|(fun(var: any, multiple: boolean): res: boolean)
local function type_fun(t)
  validate({ t = { t, { 'string' } } })

  local ALLOWED_TYPES = {
    is_bool = 'boolean',
    is_fun = 'function',
    is_num = 'number',
    is_str = 'string',
    is_tbl = 'table',
  }
  local ret, name = true, ''
  for k, _type in pairs(ALLOWED_TYPES) do
    if _type == t then
      ret, name = false, k
      break
    end
  end

  assert(not ret, ('Invalid type `%s`'):format(t))

  ---@param var any
  ---@param multiple boolean
  ---@return boolean res
  ---@overload fun(var: any): res: boolean
  return function(var, multiple)
    validate({ multiple = { multiple, { 'boolean', 'nil' }, true } })
    if multiple == nil then
      multiple = false
    end

    local res = true
    if not multiple then
      res = var ~= nil and type(var) == t
    elseif var == nil or type(var) ~= 'table' then
      res = false
    else
      for _, v in ipairs(var) do
        if t == nil or type(v) ~= t then
          vim.notify(
            ('(user_api.check.value.%s): Input is not a table (`multiple` is `true`)'):format(name),
            vim.log.levels.WARN
          )
          res = false
          break
        end
      end
    end
    return res
  end
end

---Value checking utilities.
---
---Pretty much reserved for data checking, type checking
---and conditional operations.
--- ---
---@class User.Check.Value
local M = {}

---Checks whether a value is a string
--- ---
M.is_str = type_fun('string')

---Checks whether a value is a boolean
--- ---
M.is_bool = type_fun('boolean')

---Checks whether a value is a function
--- ---
M.is_fun = type_fun('function')

---Checks whether a value is a number
--- ---
M.is_num = type_fun('number')

---Checks whether a value is a table
--- ---
M.is_tbl = type_fun('table')

---Checks whether a value is an integer,
---i.e. _greater than or equal to `0` and a **whole number**_.
--- ---
---@param var any Any data type to be checked if it's an integer
---@param multiple boolean Tell the integer you're checking for multiple values. (Default: `false`)
---@return boolean is_int
---@overload fun(var: any): is_int: boolean
function M.is_int(var, multiple)
  validate({ multiple = { multiple, { 'boolean', 'nil' }, true } })
  if multiple == nil then
    multiple = false
  end

  local res = true
  if not multiple then
    res = type(var) == 'number' and var == math.floor(var) and var == math.ceil(var)
  elseif type(var) ~= 'table' then
    vim.notify('(user_api.check.value.is_int): Input is not a table (`multiple` is true)', vim.log.levels.WARN)
    res = false
  else
    for _, v in ipairs(var) do
      if not (type(v) == 'number' and v == math.floor(v) and v == math.ceil(v)) then
        res = false
        break
      end
    end
  end
  return res
end

---Returns whether one or more given string/number/table are **empty**.
---
---Scenarios included if `multiple` is `false`:
---
--- - Is an empty string (`x == ''`)
--- - Is an integer equal to zero (`x == 0`)
--- - Is an empty table (`{}`)
---
---If `multiple` is `true` apply the above to a table of allowed values.
---
---**THIS FUNCTION IS NOT RECURSIVE!**
--- ---
---@param data string|number|table
---@param multiple boolean
---@return boolean is_empty
---@overload fun(data: string|number|table): is_empty: boolean
function M.empty(data, multiple)
  validate({
    data = { data, { 'string', 'table', 'number' } },
    multiple = { multiple, { 'boolean', 'nil' }, true },
  })
  if multiple == nil then
    multiple = false
  end

  local res = false
  if type(data) == 'string' then
    res = data == ''
  elseif type(data) == 'number' then
    res = data == 0
  elseif not multiple then
    res = vim.tbl_isempty(data)
  elseif vim.tbl_isempty(data) then
    vim.notify('(user_api.check.value.empty): No values to check', vim.log.levels.WARN)
    res = true
  else
    for _, val in ipairs(data) do
      if M.empty(val, false) then -- HACK: PASSING `false` TO AVOID RECURSIVE CHECKING
        res = true
        break
      end
    end
  end
  return res
end

---Checks whether a certain number `num` is within a specified range.
--- ---
---@param num number The number to be checked
---@param low number The low limit
---@param high number The high limit
---@param eq { high?: boolean, low?: boolean } A table that defines how equalities will be made
---@return boolean in_range
---@overload fun(num: number, low: number, high: number): in_range: boolean
function M.num_range(num, low, high, eq)
  validate({
    num = { num, { 'number' } },
    low = { low, { 'number' } },
    high = { high, { 'number' } },
    eq = { eq, { 'table', 'nil' }, true },
  })

  eq = eq or { low = true, high = true }

  validate({
    ['eq.low'] = { eq.low, { 'boolean', 'nil' }, true },
    ['eq.high'] = { eq.high, { 'boolean', 'nil' }, true },
  })
  if eq.high == nil then
    eq.high = true
  end
  if eq.low == nil then
    eq.low = true
  end

  if low > high then
    low, high = high, low
  end

  local res ---@type boolean
  if eq.high and eq.low then
    res = num >= low and num <= high
  elseif eq.high and not eq.low then
    res = num > low and num <= high
  elseif not eq.high and eq.low then
    res = num >= low and num < high
  else
    res = num > low and num < high
  end
  return res
end

---@generic K
---@param field K
---@param T table<K, any>
---@return boolean found
function M.fields(field, T)
  validate({
    field = { field, { 'string', 'number', 'table', 'nil' }, true },
    T = { T, { 'table' } },
  })

  local found = true
  if type(field) ~= 'table' then
    found = T[field] ~= nil
  else
    for _, v in ipairs(field) do
      if not M.fields(v, T) then
        found = false
        break
      end
    end
  end
  return found
end

---@overload fun(values: any[]|table<string, any>, T: table): res: boolean
---@overload fun(values: any[]|table<string, any>, T: table, return_keys: false): res: boolean
---@overload fun(values: any[]|table<string, any>, T: table, return_keys: true): res: table|string|integer
function M.tbl_values(values, T, return_keys)
  validate({
    values = { values, { 'table' } },
    T = { T, { 'table' } },
    return_keys = { return_keys, { 'boolean', 'nil' }, true },
  })
  if return_keys == nil then
    return_keys = false
  end

  local res = return_keys and {} or false ---@type boolean|string|integer|table
  for _, val in pairs(values) do
    for k, v in pairs(T) do
      if v == val then
        if return_keys then
          table.insert(res, k)
        else
          res = true
          break
        end
      end
    end

    -- If not returning key, and no value found after previous sweep, break
    if not (return_keys or res) then
      break
    end
  end
  return return_keys and (#res == 1 and res[1] or (M.empty(res) and false or res)) or res
end

---@param type_str Types
---@param T table
---@return boolean is_single_type
function M.single_type_tbl(type_str, T)
  validate({
    type_str = { type_str, { 'string' } },
    T = { T, { 'table' } },
  })
  assert(
    vim.list_contains({ 'boolean', 'function', 'number', 'string', 'table' }, type_str),
    ('(user_api.check.value.single_type_tbl): Wrong type `%s`.'):format(type_str)
  )

  local res = true
  if vim.tbl_isempty(T) then
    vim.notify('(user_api.check.value.single_type_tbl): Expected a non-empty table!', vim.log.levels.ERROR)
    res = false
  else
    for _, v in pairs(T) do
      if (type_str == 'nil' and v ~= nil) or type(v) ~= type_str then
        res = false
        break
      end
    end
  end
  return res
end

---Checks whether a certain `num` does not exceed table index range
---_i.e._ `num >= 1 and num <= #T`.
---
---If the table is empty, then it'll return `false`.
--- ---
---@param index integer
---@param T table
---@return boolean found
function M.in_tbl_range(index, T)
  validate({
    index = { index, { 'number' } },
    T = { T, { 'table' } },
  })

  if vim.tbl_isempty(T) then
    return false
  end
  return index >= 1 and index <= #T
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
