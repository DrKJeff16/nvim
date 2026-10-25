local validate = require('user_api.check.exists').validate

---@class User.Util
---@field autocmd User.Util.Autocmd
---@field notify User.Util.Notify
---@field spinner User.Util.Spinner
---@field string User.Util.String
local M = {}

---@generic T: table, F
---@param t T
---@param k any
---@param fallback F
---@return F fallback
local function get(t, k, fallback)
  return M.get(t, k, function()
    return M.rawset(t, k, fallback)
  end, true)
end

setmetatable(M, {
  __index = function(self, k) ---@param self User.Util
    local raw = M.get(self, k)
    if raw ~= nil then
      return raw
    end

    if type(k) ~= 'string' then
      return
    end

    ---@cast k string
    if require('user_api.check.exists').module('user_api.util.' .. k) then
      return get(self, k, require('user_api.util.' .. k))
    end
    require('user_api.backtrace')(vim.log.levels.ERROR, ('Invalid key: `%s`'):format(k))
  end,
})

---Get rid of all duplicates in input table.
---
---If table is empty, it'll just return it as-is.
---
---If the data passed to the function is not a table, an error will be raised.
--- ---
---@generic T: table
---@param T T
---@param key any
---@return T NT
---@overload fun(T: T): NT: T
---@nodiscard
function M.dedup(T, key)
  validate({ T = { T, { 'table' } } })
  if vim.tbl_isempty(T) then
    return T
  end

  local names, NT = {}, {}
  local list = vim.islist(T)
  for k, v in pairs(T) do
    local not_dup = false
    if type(v) == 'table' then
      if key == nil then
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
  assert(
    vim.list_contains({ 'scope', 'ft', 'buf', 'win' }, param),
    ('Bad parameter: `%s`\nCan only accept `scope`, `ft`, `buf` or `win`!'):format(vim.inspect(param))
  )
  if param == 'scope' then
    param_value = param_value or 'local'
    assert(
      vim.list_contains({ 'global', 'local' }, param_value),
      ('Bad param value `%s`\nCan only accept `global` or `local`!'):format(vim.inspect(param_value))
    )
  end
  if param == 'ft' then
    assert(param_value and type(param_value) == 'string', 'Missing/bad value for `ft` parameter!')
  end
  if vim.list_contains({ 'win', 'buf' }, param) then
    assert(param_value ~= nil, 'Missing value for `win` / `buf` parameter')
    assert(
      type(param_value) == 'number' and require('user_api.check').is_int(param_value),
      'Bad value for `win` / `buf` parameter'
    )
  end

  if type(option) == 'string' then
    return vim.api.nvim_get_option_value(option, { [param] = param_value })
  end

  local values = {} ---@type vim.bo|vim.wo
  for _, opt in ipairs(option) do
    local ok, res = pcall(vim.api.nvim_get_option_value, opt, { [param] = param_value })
    assert(ok and res, ('Invalid option: `%s`'):format(opt))
    values[opt] = res
  end
  return values
end

---@overload fun(option: string, value: any)
---@overload fun(option: table<string, any>)
---@overload fun(option: string, value: any, param: 'scope', param_value: 'local'|'global')
---@overload fun(option: string, value: any, param: 'filetype', param_value: string)
---@overload fun(option: string, value: any, param: 'buf'|'win', param_value: integer)
---@overload fun(option: table<string, any>, value: nil, param: 'scope', param_value: 'local'|'global')
---@overload fun(option: table<string, any>, value: nil, param: 'filetype', param_value: string)
---@overload fun(option: table<string, any>, value: nil, param: 'buf'|'win', param_value: integer)
function M.optset(option, value, param, param_value)
  validate({
    option = { option, { 'string', 'table' } },
    param = { param, { 'string', 'nil' }, true },
    param_value = { param_value, { 'string', 'number', 'nil' }, true },
  })
  param = param or 'buf'
  if type(option) == 'table' then
    assert(value == nil, 'Bad option value spec!')
  end
  assert(
    vim.list_contains({ 'scope', 'filetype', 'buf', 'win' }, param),
    ('Bad parameter: `%s`\nCan only accept `scope`, `filetype`, `buf` or `win`!'):format(vim.inspect(param))
  )

  if param == 'scope' then
    ---@cast param_value 'global'|'local'
    param_value = param_value or 'local'
    assert(
      vim.list_contains({ 'global', 'local' }, param_value),
      ('Bad param value `%s`\nCan only accept `global` or `local`!'):format(vim.inspect(param_value))
    )
  end
  if param == 'filetype' then
    assert(param_value and type(param_value) == 'string', 'Missing/bad value for `filetype` parameter!')
  end
  if vim.list_contains({ 'win', 'buf' }, param) then
    assert(
      param_value and type(param_value) == 'number' and require('user_api.check').is_int(param_value),
      'Missing/bad value for `win`/`buf` parameter!'
    )
  end

  if type(option) == 'string' then
    vim.api.nvim_set_option_value(option, value, { [param] = param_value })
  else
    local cb ---@type fun(opt: string, val: any)
    if param == 'buf' then
      cb = function(opt, val)
        vim.bo[param_value][opt] = val
      end
    elseif param == 'win' then
      cb = function(opt, val)
        vim.wo[param_value][opt] = val
      end
    elseif vim.list_contains({ 'filetype', 'scope' }, param) then
      cb = function(opt, val)
        vim.api.nvim_set_option_value(opt, val, { [param] = param_value })
      end
    end
    for opt, val in pairs(option) do
      assert(pcall(cb, opt, val), ('Unable to set option `%s` for `%s` level `%s`'):format(opt, param, param_value))
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
    for _, c in ipairs(char) do
      if c:len() > str:len() then
        return str
      end
      str = M.lstrip(c, str)
    end
  elseif vim.startswith(str, char) or char:len() > str:len() then
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
    str = new_str
  end
  return str
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
    for _, c in ipairs(char) do
      if c:len() > str:len() then
        return str
      end
      str = M.rstrip(c, str)
    end
  elseif vim.startswith(str:reverse(), char) or char:len() > str:len() then
    str = M.lstrip(char, str:reverse()):reverse()
  end
  return str
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
    for _, c in ipairs(char) do
      if c:len() > str:len() then
        return str
      end
      str = M.strip(c, str)
    end
  elseif char:len() <= str:len() then
    str = M.rstrip(char, M.lstrip(char, str))
  end
  return str
end

---@param s string[]|string
---@param bufnr? integer
---@return table<string, any> res
function M.get_opts_tbl(s, bufnr)
  validate({
    s = { s, { 'string', 'table' } },
    bufnr = { bufnr, { 'number', 'nil' }, true },
  })
  bufnr = bufnr or vim.api.nvim_get_current_buf()

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

      local res, len = {}, #keys ---@type table<string, any>, integer
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
  validate({ T = { T, { 'table' } }, fields = { fields, { 'string', 'number', 'table' } } })

  if type(fields) == 'string' or type(fields) == 'number' and require('user_api.check').fields(fields, T) then
    for k in pairs(T) do
      if k == fields then
        T[k] = nil
      end
    end
  elseif type(fields) == 'table' then
    for k in pairs(T) do
      if vim.list_contains(fields, k) then
        T[k] = nil
      end
    end
  end
  return T
end

---@generic T: table
---@param T T
---@param values table
---@param max_instances integer
---@return T res
---@overload fun(T: T, values: table): res: T
---@nodiscard
function M.strip_values(T, values, max_instances)
  validate({
    T = { T, { 'table' } },
    values = { values, { 'table' } },
    max_instances = { max_instances, { 'table', 'nil' }, true },
  })
  max_instances = max_instances or 0

  assert(not vim.tbl_isempty(T) and #values > 0, 'Empty tables as args')

  local res, count = {}, 0 ---@type table<string, any>, integer
  for k, v in pairs(T) do
    -- Both arguments can't be true simultaneously
    local xor = M.xor((max_instances == 0), (max_instances ~= 0 and max_instances > count))
    if ((xor and not vim.list_contains(values, v)) or not xor) and require('user_api.check').is_int(k) then
      table.insert(res, v)
    elseif not xor or (xor and not vim.list_contains(values, v)) then
      res[k] = v
    elseif xor and vim.list_contains(values, v) then
      count = count + 1
    end
  end
  return res
end

---@param s string
---@param bufnr integer
---@return function callback
---@overload fun(): callback: function
---@overload fun(s: string): callback: function
---@overload fun(s: nil, bufnr: integer): callback: function
function M.ft_set(s, bufnr)
  validate({
    s = { s, { 'string', 'nil' }, true },
    bufnr = { bufnr, { 'number', 'nil' }, true },
  })

  return function()
    vim.api.nvim_set_option_value('filetype', s or '', { buf = bufnr or vim.api.nvim_get_current_buf() })
  end
end

---@param bufnr integer
---@return string|''|'acwrite'|'help'|'nofile'|'nowrite'|'prompt'|'quickfix'|'terminal' bt
---@overload fun(): bt: string|''|'acwrite'|'help'|'nofile'|'nowrite'|'prompt'|'quickfix'|'terminal'
function M.bt_get(bufnr)
  validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })

  return vim.api.nvim_get_option_value('buftype', { buf = bufnr or vim.api.nvim_get_current_buf() })
end

---@param bufnr integer
---@return string ft
---@overload fun(): ft: string
function M.ft_get(bufnr)
  validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })

  return vim.api.nvim_get_option_value('filetype', { buf = bufnr or vim.api.nvim_get_current_buf() })
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

  return T, table.remove(T, idx)
end

---@param c string
---@param direction 'next'|'prev'
---@return string displaced
---@overload fun(c: string): displaced: string
---@nodiscard
function M.displace_letter(c, direction)
  validate({
    c = { c, { 'string' } },
    direction = { direction, { 'string', 'nil' }, true },
  })
  direction = vim.list_contains({ 'next', 'prev' }, direction) and direction or 'next'
  return c == '' and 'a'
    or M.mv_tbl_values(
      vim.deepcopy(
        require('user_api.check').fields(c, M.string.alphabet.lower_map) and M.string.alphabet.lower_map
          or M.string.alphabet.upper_map
      ),
      1,
      direction == 'prev' and 'r' or 'l'
    )[c]
end

---@overload fun(data: string): res: string
---@overload fun(data: string[]): res: string[]
function M.discard_dups(data)
  if type(data) ~= 'string' and type(data) ~= 'table' then
    vim.notify('Input is not valid!', vim.log.levels.ERROR, {
      animate = true,
      hide_from_history = false,
      timeout = 2750,
      title = '(user_api.util.discard_dups)',
    })
    return data
  end

  local res ---@type string[]|string
  if type(data) == 'string' then
    res = data:sub(1, 1)
    local i = 2
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

---@generic T: table
---@param T T
---@return T reversed
function M.reverse_tbl(T)
  validate({ T = { T, { 'table' } } })
  assert(not vim.tbl_isempty(T), '(user_api.util.reverse_tbl): Empty table')
  assert(vim.islist(T), '(user_api.util.reverse_tbl): Table is not list-like')

  for i = 1, math.floor(#T / 2), 1 do
    T[i], T[#T - i + 1] = T[#T - i + 1], T[i]
  end
  return T
end

---@generic T: table, V
---@param t T
---@param k string|integer
---@param v V
---@return V v
function M.rawset(t, k, v)
  rawset(t, k, v)
  return v
end

---@generic T: table, F, K, V
---@param t T<K, V>
---@param k K
---@param fallback F|fun(): raw: F
---@param is_rawset boolean
---@return F|V?
---@overload fun(t: T<K, V>, k: K): raw: V?
---@overload fun(t: T<K, V>, k: K, fallback: F): raw: F|V
---@overload fun(t: T<K, V>, k: K, fallback: F, is_rawset: false): raw: F|V
---@overload fun(t: T<K, V>, k: K, fallback: (fun(): raw: F), is_rawset: true): raw: F|V
function M.get(t, k, fallback, is_rawset)
  if is_rawset == nil then
    is_rawset = false
  end

  if k ~= nil then
    local raw = rawget(t, k) or nil --[[@as unknown|nil|?]]
    if raw ~= nil or fallback == nil then
      return raw
    end

    if is_rawset then
      ---@cast fallback fun(): any
      local _, res = pcall(fallback)
      return res
    end

    ---@cast fallback any
    return fallback
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
