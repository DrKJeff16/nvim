local ERROR = vim.log.levels.ERROR
local curr_buf = vim.api.nvim_get_current_buf
local validate = require('user_api.check').validate

---@class User.Util
---@field autocmd User.Util.Autocmd
---@field notify User.Util.Notify
---@field spinner User.Util.Spinner
---@field string User.Util.String
local M = {}

---Get rid of all duplicates in input table.
---
---If table is empty, it'll just return it as-is.
---
---If the data passed to the function is not a table,
---an error will be raised.
--- ---
---@generic T: table
---@param T T
---@param key? string|integer
---@return T NT
---@nodiscard
function M.dedup(T, key)
  validate({
    T = { T, { 'table' } },
    key = { key, { 'string', 'nil' }, true },
  })
  key = (key and key ~= '') and key or nil
  if vim.tbl_isempty(T) then
    return T
  end

  local names, NT = {}, {}
  local list = vim.islist(T)
  for k, v in pairs(T) do
    local not_dup = false
    if type(v) == 'table' then
      if not key then
        not_dup = not vim.tbl_contains(NT, function(val)
          return vim.deep_equal(val, v)
        end, { predicate = true })
      else
        not_dup = not vim.tbl_contains(names, function(val)
          return vim.deep_equal(val, v[key])
        end, { predicate = true })
        if not_dup then
          table.insert(names, v[key])
        end
      end
    else
      not_dup = not vim.tbl_contains(NT, function(val)
        return vim.deep_equal(val, v)
      end, { predicate = true })
    end
    if not_dup then
      if list then
        table.insert(NT, v)
      else
        NT[k] = v
      end
    end
  end

  return NT
end

---@overload fun(option: string): value: any
---@overload fun(option: string, param: 'buf'|'win', param_value: integer): value: any
---@overload fun(option: string, param: 'ft', param_value: string): value: any
---@overload fun(option: string, param: 'scope', param_value: 'local'|'global'): value: any
---@overload fun(option: string[]): value: any
---@overload fun(option: string[], param: 'buf'|'win', param_value: integer): value: any
---@overload fun(option: string[], param: 'ft', param_value: string): value: any
---@overload fun(option: string[], param: 'scope', param_value: 'local'|'global'): value: any
function M.optget(option, param, param_value)
  validate({
    option = { option, { 'string', 'table' } },
    param = { param, { 'string', 'nil' }, true },
    param_value = { param_value, { 'string', 'number', 'nil' }, true },
  })
  param = param or 'buf'
  if not vim.list_contains({ 'scope', 'ft', 'buf', 'win' }, param) then
    error(('Bad parameter: `%s`\nCan only accept `scope`, `ft`, `buf` or `win`!'):format(vim.inspect(param)), ERROR)
  end
  if param == 'scope' then
    param_value = param_value or 'local'
    if not vim.list_contains({ 'global', 'local' }, param_value) then
      error(('Bad param value `%s`\nCan only accept `global` or `local`!'):format(vim.inspect(param_value)), ERROR)
    end
  end
  if param == 'ft' and (not param_value or type(param_value) ~= 'string') then
    error('Missing/bad value for `ft` parameter!', ERROR)
  end
  if
    vim.list_contains({ 'win', 'buf' }, param)
    and not (param_value and type(param_value) == 'number' and require('user_api.check').is_int(param_value))
  then
    error('Missing/bad value for `win`/`buf` parameter!', ERROR)
  end

  if type(option) == 'string' then
    return vim.api.nvim_get_option_value(option, { [param] = param_value })
  end

  local values = {} ---@type vim.bo|vim.wo
  for _, opt in ipairs(option) do
    local ok, res = pcall(vim.api.nvim_get_option_value, opt, { [param] = param_value })
    if not (ok and res) then
      error(('Invalid option: `%s`'):format(opt), ERROR)
    end
    values[opt] = res
  end

  return values
end

---@overload fun(option: string, value: any)
---@overload fun(option: string, value: any, param: 'scope', param_value: 'local'|'global')
---@overload fun(option: string, value: any, param: 'ft', param_value: string)
---@overload fun(option: string, value: any, param: 'buf'|'win', param_value: integer)
function M.optset(option, value, param, param_value)
  validate({
    option = { option, { 'string', 'table' } },
    param = { param, { 'string', 'nil' }, true },
    param_value = { param_value, { 'string', 'number', 'nil' }, true },
  })
  if type(option) == 'table' and value ~= nil then
    error('Bad option value spec!', ERROR)
  end
  param = param or 'buf'
  if not vim.list_contains({ 'scope', 'ft', 'buf', 'win' }, param) then
    error(('Bad parameter: `%s`\nCan only accept `scope`, `ft`, `buf` or `win`!'):format(vim.inspect(param)), ERROR)
  end
  if param == 'scope' then
    ---@cast param_value 'global'|'local'
    param_value = param_value or 'local'
    if not vim.list_contains({ 'global', 'local' }, param_value) then
      error(('Bad param value `%s`\nCan only accept `global` or `local`!'):format(vim.inspect(param_value)), ERROR)
    end
  end
  if param == 'ft' and (not param_value or type(param_value) ~= 'string') then
    error('Missing/bad value for `ft` parameter!', ERROR)
  end
  if
    vim.list_contains({ 'win', 'buf' }, param)
    and not (param_value and type(param_value) == 'number' and require('user_api.check').is_int(param_value))
  then
    error('Missing/bad value for `win`/`buf` parameter!', ERROR)
  end

  if type(option) == 'string' then
    vim.api.nvim_set_option_value(option, value, { [param] = param_value })
  else
    for opt, val in pairs(option) do
      vim.api.nvim_set_option_value(opt, val, { [param] = param_value })
    end
  end
end

function M.has_words_before()
  local col = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[2]
  if col == 0 then
    return false
  end
  return vim.api.nvim_get_current_line():sub(col, col):match('%s') == nil
end

---Left strip given a leading string (or list of strings) within a string, if any.
--- ---
---@param char string[]|string
---@param str string
---@return string new_str
---@nodiscard
function M.lstrip(char, str)
  validate({
    char = { char, { 'string', 'table' } },
    str = { str, { 'string' } },
  })
  if str == '' then
    return str
  end

  if type(char) == 'table' then
    if not vim.tbl_isempty(char) then
      for _, c in ipairs(char) do
        if c:len() > str:len() then
          return str
        end
        str = M.lstrip(c, str)
      end
    end
    return str
  end

  if not vim.startswith(str, char) or char:len() > str:len() then
    return str
  end

  local i, len, new_str, other = 1, str:len(), '', false
  while i <= len and i + char:len() - 1 <= len do
    if str:sub(i, i + char:len() - 1) ~= char and not other then
      other = true
    end
    if other then
      new_str = ('%s%s'):format(new_str, str:sub(i, i))
    end
    i = i + 1
  end
  return new_str
end

---Right strip given a leading string (or list of strings) within a string, if any.
--- ---
---@param char string[]|string
---@param str string
---@return string new_str
---@nodiscard
function M.rstrip(char, str)
  validate({
    char = { char, { 'string', 'table' } },
    str = { str, { 'string' } },
  })
  if str == '' then
    return str
  end

  if type(char) == 'table' then
    if not vim.tbl_isempty(char) then
      for _, c in ipairs(char) do
        if c:len() > str:len() then
          return str
        end
        str = M.rstrip(c, str)
      end
    end
    return str
  end

  if not vim.startswith(str:reverse(), char) or char:len() > str:len() then
    return str
  end

  return M.lstrip(char, str:reverse()):reverse()
end

---Strip given a leading string (or list of strings) within a string, if any, bidirectionally.
--- ---
---@param char string[]|string
---@param str string
---@return string new_str
---@nodiscard
function M.strip(char, str)
  validate({
    char = { char, { 'string', 'table' } },
    str = { str, { 'string' } },
  })
  if str == '' then
    return str
  end

  if type(char) == 'table' then
    if not vim.tbl_isempty(char) then
      for _, c in ipairs(char) do
        if c:len() > str:len() then
          return str
        end
        str = M.strip(c, str)
      end
    end
    return str
  end

  if char:len() > str:len() then
    return str
  end

  return M.rstrip(char, M.lstrip(char, str))
end

---@param s string[]|string
---@param bufnr? integer
---@return table<string, any> res
function M.get_opts_tbl(s, bufnr)
  validate({
    s = { s, { 'string', 'table' } },
    bufnr = { bufnr, { 'number', 'nil' }, true },
  })
  bufnr = bufnr or curr_buf()

  local res = {} ---@type table<string, any>
  if type(s) == 'string' then
    res[s] = vim.api.nvim_get_option_value(s, { buf = bufnr })
  else
    for _, opt in ipairs(s) do
      res[opt] = M.get_opts_tbl(opt, bufnr)
    end
  end
  return res
end

---@generic T: table
---@param T T
---@param steps? integer
---@param direction? 'l'|'r'
---@return T res
function M.mv_tbl_values(T, steps, direction)
  validate({
    T = { T, { 'table' } },
    steps = { steps, { 'number', 'nil' }, true },
    direction = { direction, { 'string', 'nil' }, true },
  })
  steps = steps > 0 and steps or 1
  direction = (direction and vim.list_contains({ 'l', 'r' }, direction)) and direction or 'r'

  ---@generic T: table
  ---@class DirectionFuns
  ---@field l fun(t: T): res: T
  ---@field r fun(t: T): res: T
  local direction_funcs = {
    r = function(t)
      local keys = vim.tbl_keys(t) --[[@as string[]\]]
      table.sort(keys)

      local res = {} ---@type table<string, any>
      for i, v in ipairs(keys) do
        res[v] = t[keys[i == 1 and #keys or (i - 1)]]
      end
      return res
    end,
    l = function(t)
      local keys = vim.tbl_keys(t) --[[@as string[]\]]
      table.sort(keys)

      local res = {} ---@type table<string, any>
      local len = #keys
      for i, v in ipairs(keys) do
        res[v] = t[keys[i == len and 1 or (i + 1)]]
      end
      return res
    end,
  }

  local res, func = T, direction_funcs[direction]
  while steps > 0 do
    res = func(res)
    steps = steps - 1
  end
  return res
end

---@param x boolean
---@param y boolean
---@return boolean xor
function M.xor(x, y)
  validate({ x = { x, { 'boolean' } }, y = { y, { 'boolean' } } })

  return (x and not y) or (not x and y)
end

---@generic T
---@param T T
---@param fields (string|integer)[]|string|integer
---@return T T
function M.strip_fields(T, fields)
  validate({
    T = { T, { 'table' } },
    fields = { fields, { 'string', 'number', 'table' } },
  })

  if type(fields) == 'string' or type(fields) == 'number' then
    if require('user_api.check').fields(fields, T) then
      for k in pairs(T) do
        ---@cast k string|integer
        if k == fields then
          T[k] = nil
        end
      end
    end
  else
    for k in pairs(T) do
      ---@cast k string|integer
      if vim.list_contains(fields, k) then
        T[k] = nil
      end
    end
  end
  return T
end

---@generic T
---@param T T
---@param values any[]
---@param max_instances? integer
---@return T res
function M.strip_values(T, values, max_instances)
  validate({
    T = { T, { 'table' } },
    values = { values, { 'table' } },
    max_instances = { max_instances, { 'table', 'nil' }, true },
  })

  if vim.tbl_isempty(T) or vim.tbl_isempty(values) then
    error('(user_api.util.strip_values): Empty tables as args!', ERROR)
  end

  max_instances = max_instances or 0
  local res, count = {}, 0 ---@type table<string, any>, integer
  for k, v in pairs(T) do
    -- Both arguments can't be true simultaneously
    if M.xor((max_instances == 0), (max_instances ~= 0 and max_instances > count)) then
      if not vim.list_contains(values, v) and require('user_api.check').is_int(k) then
        table.insert(res, v)
      elseif not vim.list_contains(values, v) then
        res[k] = v
      else
        count = count + 1
      end
    elseif require('user_api.check').is_int(k) then
      table.insert(res, v)
    else
      res[k] = v
    end
  end
  return res
end

---@param s? string
---@param bufnr? integer
---@return function setter
function M.ft_set(s, bufnr)
  validate({
    s = { s, { 'string', 'nil' }, true },
    bufnr = { bufnr, { 'number', 'nil' }, true },
  })

  return function()
    vim.api.nvim_set_option_value('filetype', s or '', { buf = bufnr or curr_buf() })
  end
end

---@param bufnr? integer
---@return string|''|'acwrite'|'help'|'nofile'|'nowrite'|'prompt'|'quickfix'|'terminal' bt
function M.bt_get(bufnr)
  validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })

  return vim.api.nvim_get_option_value('buftype', { buf = bufnr or curr_buf() })
end

---@param bufnr? integer
---@return string ft
function M.ft_get(bufnr)
  validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })

  return vim.api.nvim_get_option_value('filetype', { buf = bufnr or curr_buf() })
end

---@generic T, V
---@param T T
---@param V V
---@return T T
---@return V|nil|? val
function M.pop_values(T, V)
  validate({ T = { T, { 'table' } } })

  local idx = 0
  for i, v in ipairs(T) do
    if v == V then
      idx = i
      break
    end
  end
  if idx < 1 or idx > #T then
    return T
  end

  local popped = table.remove(T, idx)
  return T, popped
end

---@param c string
---@param direction? 'next'|'prev'
---@return string displaced
function M.displace_letter(c, direction)
  validate({
    c = { c, { 'string' } },
    direction = { direction, { 'string', 'nil' }, true },
  })
  direction = vim.list_contains({ 'next', 'prev' }, direction) and direction or 'next'
  if c == '' then
    return 'a'
  end

  local LOWER = vim.deepcopy(require('user_api.util.string').alphabet.lower_map)
  local UPPER = vim.deepcopy(require('user_api.util.string').alphabet.upper_map)
  return M.mv_tbl_values(
    require('user_api.check').fields(c, LOWER) and LOWER or UPPER,
    1,
    direction == 'prev' and 'r' or 'l'
  )[c]
end

---@overload fun(data: string): res: string
---@overload fun(data: string[]): res: string[]
function M.discard_dups(data)
  if type(data) ~= 'string' and type(data) ~= 'table' then
    vim.notify('Input is not valid!', ERROR, {
      animate = true,
      hide_from_history = false,
      timeout = 2750,
      title = '(user_api.util.discard_dups)',
    })
    return data
  end

  local res ---@type string[]|string
  if type(data) == 'string' then
    local i = 2
    res = data:sub(1, 1)
    while i < data:len() do
      local c = data:sub(i, i)
      if not res:match(c) then
        res = res .. c
      end
      i = i + 1
    end
  else
    res = {}
    for k, v in pairs(data) do
      if not vim.tbl_contains(res, v) then
        res[k] = v
      end
    end
  end
  return res
end

---@generic T
---@param T T
---@return T reversed
function M.reverse_tbl(T)
  validate({ T = { T, { 'table' } } })
  if vim.tbl_isempty(T) then
    error('(user_api.util.reverse_tbl): Empty table!', ERROR)
  end

  for i = 1, math.floor(#T / 2), 1 do
    T[i], T[#T - i + 1] = T[#T - i + 1], T[i]
  end
  return T
end

local Util = setmetatable(M, { ---@type User.Util
  __index = function(self, k)
    if require('user_api.check').module('user_api.util.' .. k) then
      return require('user_api.util.' .. k)
    end
    local res = rawget(self, k)
    if res then
      return res
    end
    require('user_api.backtrace')(vim.log.levels.ERROR, ('Invalid key: `%s`'):format(k))
  end,
})

return Util
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
