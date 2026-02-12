local ERROR = vim.log.levels.ERROR
local curr_buf = vim.api.nvim_get_current_buf
local curr_win = vim.api.nvim_get_current_win
local in_list = vim.list_contains
local validate = require('user_api.check').validate

---@class User.Util
local Util = {}

Util.notify = require('user_api.util.notify')
Util.au = require('user_api.util.autocmd')
Util.string = require('user_api.util.string')

---@param names string[]|string
---@param opts vim.api.keyset.option
---@return vim.bo|vim.wo values
function Util.optget(names, opts)
  validate({
    names = { names, { 'string', 'table' } },
    opts = { opts, { 'table' } },
  })
  if vim.tbl_isempty(opts) or vim.islist(opts) then
    error('Empty or incorrect opts table!', ERROR)
  end

  local valid = false
  for _, key in ipairs({ 'buf', 'filetype', 'scope', 'win' }) do
    if vim.list_contains(vim.tbl_keys(opts), key) then
      valid = true
      break
    end
  end
  if not valid then
    error('The opts table is not correctly formatted!', ERROR)
  end

  if require('user_api.check.value').is_tbl(names) then
    ---@cast names string[]
    local values = {} ---@type vim.bo|vim.wo
    for _, name in ipairs(names) do
      values[name] = vim.api.nvim_get_option_value(name, opts)
    end
    return values
  end

  ---@cast names string
  return { [names] = vim.api.nvim_get_option_value(names, opts) }
end

---@param values vim.bo|vim.wo
---@param opts vim.api.keyset.option
function Util.optset(values, opts)
  validate({
    values = { values, { 'table' } },
    opts = { opts, { 'table' } },
  })
  if vim.tbl_isempty(opts) or vim.islist(opts) then
    error('Empty or incorrect opts table!', ERROR)
  end

  local valid = false
  for _, key in ipairs({ 'buf', 'filetype', 'scope', 'win' }) do
    if vim.list_contains(vim.tbl_keys(opts), key) then
      valid = true
      break
    end
  end
  if not valid then
    error('The opts table is not correctly formatted!', ERROR)
  end

  for name, value in pairs(values) do
    vim.api.nvim_set_option_value(name, value, opts)
  end
end

function Util.has_words_before()
  local win = curr_win()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(win))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---Left strip given a leading string (or list of strings) within a string, if any.
--- ---
---@param char string[]|string
---@param str string
---@return string new_str
---@nodiscard
function Util.lstrip(char, str)
  validate({
    char = { char, { 'string', 'table' } },
    str = { str, { 'string' } },
  })
  if str == '' then
    return str
  end

  if require('user_api.check.value').is_tbl(char) then
    ---@cast char string[]
    if not vim.tbl_isempty(char) then
      for _, c in ipairs(char) do
        if c:len() > str:len() then
          return str
        end
        str = Util.lstrip(c, str)
      end
    end
    return str
  end

  ---@cast char string
  if not vim.startswith(str, char) or char:len() > str:len() then
    return str
  end

  local i, len, new_str = 1, str:len(), ''
  local other = false
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
function Util.rstrip(char, str)
  validate({
    char = { char, { 'string', 'table' } },
    str = { str, { 'string' } },
  })
  if str == '' then
    return str
  end

  if require('user_api.check.value').is_tbl(char) then
    ---@cast char string[]
    if not vim.tbl_isempty(char) then
      for _, c in ipairs(char) do
        if c:len() > str:len() then
          return str
        end
        str = Util.rstrip(c, str)
      end
    end
    return str
  end

  ---@cast char string
  if not vim.startswith(str:reverse(), char) or char:len() > str:len() then
    return str
  end

  return Util.lstrip(char, str:reverse()):reverse()
end

---Strip given a leading string (or list of strings) within a string, if any, bidirectionally.
--- ---
---@param char string[]|string
---@param str string
---@return string new_str
---@nodiscard
function Util.strip(char, str)
  validate({
    char = { char, { 'string', 'table' } },
    str = { str, { 'string' } },
  })
  if str == '' then
    return str
  end

  if require('user_api.check.value').is_tbl(char) then
    ---@cast char string[]
    if not vim.tbl_isempty(char) then
      for _, c in ipairs(char) do
        if c:len() > str:len() then
          return str
        end
        str = Util.strip(c, str)
      end
    end
    return str
  end

  if char:len() > str:len() then
    return str
  end

  ---@cast char string
  return Util.rstrip(char, Util.lstrip(char, str))
end

---@param s string[]|string
---@param bufnr? integer
---@return table<string, any> res
---@overload fun(s: string): res: table<string, any>
---@overload fun(s: string, bufnr: integer): res: table<string, any>
---@overload fun(s: string[]): res: table<string, any>
---@overload fun(s: string[], bufnr: integer): res: table<string, any>
function Util.get_opts_tbl(s, bufnr)
  validate({
    s = { s, { 'string', 'table' } },
    bufnr = { bufnr, { 'number', 'nil' }, true },
  })
  bufnr = bufnr or curr_buf()

  local Value = require('user_api.check.value')
  local res = {} ---@type table<string, any>
  if Value.type_not_empty('string', s) then ---@cast s string
    res[s] = vim.api.nvim_get_option_value(s, { buf = bufnr })
  end
  if Value.type_not_empty('table', s) then ---@cast s string[]
    for _, opt in ipairs(s) do
      res[opt] = Util.get_opts_tbl(opt, bufnr)
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
function Util.mv_tbl_values(T, steps, direction)
  validate({
    T = { T, { 'table' } },
    steps = { steps, { 'number', 'nil' }, true },
    direction = { direction, { 'string', 'nil' }, true },
  })
  steps = steps > 0 and steps or 1
  direction = (direction ~= nil and in_list({ 'l', 'r' }, direction)) and direction or 'r'

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
function Util.xor(x, y)
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
function Util.strip_fields(T, fields)
  validate({
    T = { T, { 'table' } },
    fields = { fields, { 'string', 'number', 'table' } },
  })

  local Value = require('user_api.check.value')
  if Value.is_str(fields) then ---@cast fields string
    if not (Value.type_not_empty('string', fields) and Value.fields(fields, T)) then
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
function Util.strip_values(T, values, max_instances)
  validate({
    T = { T, { 'table' } },
    values = { values, { 'table' } },
    max_instances = { max_instances, { 'table', 'nil' }, true },
  })

  local Value = require('user_api.check.value')
  if not (Value.type_not_empty('table', T) or Value.type_not_empty('table', values)) then
    error('(user_api.util.strip_values): Empty tables as args!', ERROR)
  end

  max_instances = max_instances or 0
  local res, count = {}, 0 ---@type table<string, any>, integer
  for k, v in pairs(T) do
    -- Both arguments can't be true simultaneously
    if Util.xor((max_instances == 0), (max_instances ~= 0 and max_instances > count)) then
      if not in_list(values, v) and Value.is_int(k) then
        table.insert(res, v)
      elseif not in_list(values, v) then
        res[k] = v
      else
        count = count + 1
      end
    elseif Value.is_int(k) then
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
function Util.ft_set(s, bufnr)
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
function Util.bt_get(bufnr)
  validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })

  return vim.api.nvim_get_option_value('buftype', { buf = bufnr or curr_buf() })
end

---@param bufnr? integer
---@return string ft
---@overload fun(): ft: string
---@overload fun(bufnr: integer): ft: string
function Util.ft_get(bufnr)
  validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })

  return vim.api.nvim_get_option_value('filetype', { buf = bufnr or curr_buf() })
end

---@param T any[]
---@param V any
---@return table T
---@return any val
function Util.pop_values(T, V)
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
function Util.displace_letter(c, direction)
  validate({
    c = { c, { 'string' } },
    direction = { direction, { 'string', 'nil' }, true },
  })
  direction = in_list({ 'next', 'prev' }, direction) and direction or 'next'
  if c == '' then
    return 'a'
  end

  local Value = require('user_api.check.value')
  local mv = Util.mv_tbl_values
  local A = vim.deepcopy(Util.string.alphabet)
  local LOWER, UPPER = A.lower_map, A.upper_map
  if direction == 'prev' then
    if Value.fields(c, LOWER) then
      return mv(LOWER, 1, 'r')[c]
    end
    return mv(UPPER, 1, 'r')[c]
  end
  if Value.fields(c, LOWER) then
    return mv(LOWER, 1, 'l')[c]
  end
  return mv(UPPER, 1, 'l')[c]
end

---@param data string[]|string
---@return string[]|string res
---@overload fun(data: string): res: string
---@overload fun(data: string[]): res: string[]
function Util.discard_dups(data)
  local Value = require('user_api.check.value')
  if not (Value.type_not_empty('string', data) or Value.type_not_empty('table', data)) then
    vim.notify('Input is not valid!', ERROR, {
      animate = true,
      hide_from_history = false,
      timeout = 2750,
      title = '(user_api.util.discard_dups)',
    })
    return data
  end

  ---@cast data string
  if Value.is_str(data) then
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

---@param T any[]
---@return any[] reversed
function Util.reverse_tbl(T)
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

local M = setmetatable(Util, { ---@type User.Util
  __index = Util,
  __newindex = function()
    vim.notify('User.Util is Read-Only!', ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
