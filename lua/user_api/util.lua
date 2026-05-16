local ERROR = vim.log.levels.ERROR
local curr_buf = vim.api.nvim_get_current_buf
local in_list = vim.list_contains
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

  local list = vim.islist(T)
  local names, NT = {}, {}
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
---@overload fun(option: string[]): value: vim.bo|vim.wo
---@overload fun(option: string, param: 'scope', param_value: 'local'|'global'): value: any
---@overload fun(option: string[], param: 'scope', param_value: 'local'|'global'): value: vim.bo|vim.wo
---@overload fun(option: string, param: 'ft', param_value: string): value: any
---@overload fun(option: string[], param: 'ft', param_value: string): value: vim.bo|vim.wo
---@overload fun(option: string, param: 'buf'|'win', param_value: integer): value: any
---@overload fun(option: string[], param: 'buf', param_value: integer): value: vim.bo
---@overload fun(option: string[], param: 'win', param_value: integer): value: vim.wo
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
---@overload fun(option: vim.wo|vim.bo, value: nil)
---@overload fun(option: string, value: any, param: 'scope', param_value: 'local'|'global')
---@overload fun(option: vim.wo|vim.bo, value: nil, param: 'scope', param_value: 'local'|'global')
---@overload fun(option: string, value: any, param: 'ft', param_value: string)
---@overload fun(option: vim.wo|vim.bo, value: nil, param: 'ft', param_value: string)
---@overload fun(option: string, value: any, param: 'buf'|'win', param_value: integer)
---@overload fun(option: vim.wo|vim.bo, value: nil, param: 'buf'|'win', param_value: integer)
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
    ---@cast option string
    vim.api.nvim_set_option_value(option, value, { [param] = param_value })
    return
  end

  ---@cast option vim.wo|vim.bo
  for opt, val in pairs(option) do
    vim.api.nvim_set_option_value(opt, val, { [param] = param_value })
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

  if require('user_api.check').is_tbl(char) then
    ---@cast char string[]
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

  ---@cast char string
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

  if require('user_api.check').is_tbl(char) then
    ---@cast char string[]
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

  ---@cast char string
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

  if require('user_api.check').is_tbl(char) then
    ---@cast char string[]
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

  ---@cast char string
  return M.rstrip(char, M.lstrip(char, str))
end

---@param s string[]|string
---@param bufnr? integer
---@return table<string, any> res
---@overload fun(s: string): res: table<string, any>
---@overload fun(s: string, bufnr: integer): res: table<string, any>
---@overload fun(s: string[]): res: table<string, any>
---@overload fun(s: string[], bufnr: integer): res: table<string, any>
function M.get_opts_tbl(s, bufnr)
  validate({
    s = { s, { 'string', 'table' } },
    bufnr = { bufnr, { 'number', 'nil' }, true },
  })
  bufnr = bufnr or curr_buf()

  local res = {} ---@type table<string, any>
  if require('user_api.check').type_not_empty('string', s) then ---@cast s string
    res[s] = vim.api.nvim_get_option_value(s, { buf = bufnr })
  end
  if require('user_api.check').type_not_empty('table', s) then ---@cast s string[]
    for _, opt in ipairs(s) do
      res[opt] = M.get_opts_tbl(opt, bufnr)
    end
  end
  return res
end

---@param T table<string, any>
---@param steps? integer
---@param direction? 'l'|'r'
---@return table<string, any> res
---@overload fun(T: table<string, any>): res: table<string, any>
---@overload fun(T: table<string, any>, steps: integer): res: table<string, any>
---@overload fun(T: table<string, any>, steps?: integer, direction: 'l'|'r'): res: table<string, any>
function M.mv_tbl_values(T, steps, direction)
  validate({
    T = { T, { 'table' } },
    steps = { steps, { 'number', 'nil' }, true },
    direction = { direction, { 'string', 'nil' }, true },
  })
  steps = steps > 0 and steps or 1
  direction = (direction and in_list({ 'l', 'r' }, direction)) and direction or 'r'

  local direction_funcs = { ---@class DirectionFuns
    r = function(t) ---@param t table<string, any>
      local keys = vim.tbl_keys(t) ---@type string[]
      table.sort(keys)

      local res = {} ---@type table<string, any>
      local len = #keys
      for i, v in ipairs(keys) do
        res[v] = t[keys[i == 1 and len or (i - 1)]]
      end
      return res
    end,
    l = function(t) ---@param t table<string, any>
      local keys = vim.tbl_keys(t) ---@type string[]
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
---@return boolean
function M.xor(x, y)
  validate({ x = { x, { 'boolean' } }, y = { y, { 'boolean' } } })

  return (x and not y) or (not x and y)
end

---@param T table<string, any>
---@param fields (string|integer)[]|string|integer
---@return table<string, any> T
---@overload fun(T: table<string, any>, fields: string)
---@overload fun(T: table<string, any>, fields: integer)
---@overload fun(T: table<string, any>, fields: string[])
---@overload fun(T: table<string, any>, fields: integer[])
---@overload fun(T: table<string, any>, fields: (string|integer)[])
function M.strip_fields(T, fields)
  validate({
    T = { T, { 'table' } },
    fields = { fields, { 'string', 'number', 'table' } },
  })

  if require('user_api.check').is_str(fields) then ---@cast fields string
    if
      not (require('user_api.check').type_not_empty('string', fields) and require('user_api.check').fields(fields, T))
    then
      return T
    end
    for k, _ in pairs(T) do
      if k == fields then
        T[k] = nil
      end
    end
    return T
  end
  for k, _ in pairs(T) do
    ---@cast fields (string|integer)[]
    if in_list(fields, k) then
      T[k] = nil
    end
  end
  return T
end

---@param T table<string, any>
---@param values any[]
---@param max_instances? integer
---@return table<string, any> res
---@overload fun(T: table<string, any>, values: any[]): res: table<string, any>
function M.strip_values(T, values, max_instances)
  validate({
    T = { T, { 'table' } },
    values = { values, { 'table' } },
    max_instances = { max_instances, { 'table', 'nil' }, true },
  })

  if
    not (
      require('user_api.check').type_not_empty('table', T) or require('user_api.check').type_not_empty('table', values)
    )
  then
    error('(user_api.util.strip_values): Empty tables as args!', ERROR)
  end

  max_instances = max_instances or 0
  local res, count = {}, 0 ---@type table<string, any>, integer
  for k, v in pairs(T) do
    -- Both arguments can't be true simultaneously
    if M.xor((max_instances == 0), (max_instances ~= 0 and max_instances > count)) then
      if not in_list(values, v) and require('user_api.check').is_int(k) then
        table.insert(res, v)
      elseif not in_list(values, v) then
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
---@return function
---@overload fun(): function
---@overload fun(s: string): function
---@overload fun(s: string, bufnr: integer): function
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
---@overload fun(): bt: string|''|'acwrite'|'help'|'nofile'|'nowrite'|'prompt'|'quickfix'|'terminal'
---@overload fun(bufnr: integer): bt: string|''|'acwrite'|'help'|'nofile'|'nowrite'|'prompt'|'quickfix'|'terminal'
function M.bt_get(bufnr)
  validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })

  return vim.api.nvim_get_option_value('buftype', { buf = bufnr or curr_buf() })
end

---@param bufnr? integer
---@return string ft
---@overload fun(): ft: string
---@overload fun(bufnr: integer): ft: string
function M.ft_get(bufnr)
  validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })

  return vim.api.nvim_get_option_value('filetype', { buf = bufnr or curr_buf() })
end

---@param T any[]
---@param V any
---@return table T
---@return any val
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
  return T, table.remove(T, idx)
end

---@param c string
---@param direction? 'next'|'prev'
---@return string displaced
---@overload fun(c: string): displaced: string
---@overload fun(c: string, direction: 'next'|'prev'): displaced: string
function M.displace_letter(c, direction)
  validate({
    c = { c, { 'string' } },
    direction = { direction, { 'string', 'nil' }, true },
  })
  direction = in_list({ 'next', 'prev' }, direction) and direction or 'next'
  if c == '' then
    return 'a'
  end

  local mv = M.mv_tbl_values
  local A = vim.deepcopy(require('user_api.util.string').alphabet)
  local LOWER, UPPER = A.lower_map, A.upper_map
  if direction == 'prev' then
    if require('user_api.check').fields(c, LOWER) then
      return mv(LOWER, 1, 'r')[c]
    end
    return mv(UPPER, 1, 'r')[c]
  end
  if require('user_api.check').fields(c, LOWER) then
    return mv(LOWER, 1, 'l')[c]
  end
  return mv(UPPER, 1, 'l')[c]
end

---@param data string[]|string
---@return string[]|string res
---@overload fun(data: string): res: string
---@overload fun(data: string[]): res: string[]
function M.discard_dups(data)
  if
    not (
      require('user_api.check').type_not_empty('string', data)
      or require('user_api.check').type_not_empty('table', data)
    )
  then
    vim.notify('Input is not valid!', ERROR, {
      animate = true,
      hide_from_history = false,
      timeout = 2750,
      title = '(user_api.util.discard_dups)',
    })
    return data
  end

  ---@cast data string
  if require('user_api.check').is_str(data) then
    local res = data:sub(1, 1)
    local i = 2
    while i < data:len() do
      local c = data:sub(i, i)
      if not res:match(c) then
        res = res .. c
      end
      i = i + 1
    end
    return res
  end

  local res = {} ---@type table

  ---@cast data table
  for k, v in pairs(data) do
    if not vim.tbl_contains(res, v) then
      res[k] = v
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

  local len = #T
  for i = 1, math.floor(len / 2), 1 do
    T[i], T[len - i + 1] = T[len - i + 1], T[i]
  end
  return T
end

local Util = setmetatable(M, { ---@type User.Util
  __index = function(self, k)
    if require('user_api.check').module('user_api.util.' .. k) then
      return require('user_api.util.' .. k)
    end
    return rawget(self, k) or nil
  end,
})

return Util
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
