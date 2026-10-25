---@class User.Util.String.Alphabet.Vowels
---@field lower_list { [1]: 'a', [2]: 'e', [3]: 'i', [4]: 'o', [5]: 'u' }
---@field lower_map { a: 'a', e: 'e', i: 'i', o: 'o', u: 'u' }
---@field upper_list { [1]: 'A', [2]: 'E', [3]: 'I', [4]: 'O', [5]: 'U' }
---@field upper_map { A: 'A', E: 'E', I: 'I', O: 'O', U: 'U' }

---@class User.Util.String.Digits
---@field all { ['0']: '0', ['1']: '1', ['2']: '2', ['3']: '3', ['4']: '4', ['5']: '5', ['6']: '6', ['7']: '7', ['8']: '8', ['9']: '9' }
---@field even_list { [1]: '0', [2]: '2', [3]: '4', [4]: '6', [5]: '8' }
---@field even_map { ['0']: '0', ['2']: '2', ['4']: '4', ['6']: '6', ['8']: '8' }
---@field odd_list { [1]: '1', [2]: '3', [3]: '5', [4]: '7', [5]: '9' }
---@field odd_map { ['1']: '1', ['3']: '3', ['5']: '5', ['7']: '7', ['9']: '9' }

---@class User.Util.String.Alphabet
---@field lower_list { [1]: 'a', [2]: 'b', [3]: 'c', [4]: 'd', [5]: 'e', [6]: 'f', [7]: 'g', [8]: 'h', [9]: 'i', [10]: 'j', [11]: 'k', [12]: 'l', [13]: 'm', [14]: 'n', [15]: 'o', [16]: 'p', [17]: 'q', [18]: 'r', [19]: 's', [20]: 't', [21]: 'u', [22]: 'v', [23]: 'w', [24]: 'x', [25]: 'y', [26]: 'z' }
---@field lower_map { a: 'a', b: 'b', c: 'c', d: 'd', e: 'e', f: 'f', g: 'g', h: 'h', i: 'i', j: 'j', k: 'k', l: 'l', m: 'm', n: 'n', o: 'o', p: 'p', q: 'q', r: 'r', s: 's', t: 't', u: 'u', v: 'v', w: 'w', x: 'x', y: 'y', z: 'z' }
---@field upper_list { [1]: 'A', [2]: 'B', [3]: 'C', [4]: 'D', [5]: 'E', [6]: 'F', [7]: 'G', [8]: 'H', [9]: 'I', [10]: 'J', [11]: 'K', [12]: 'L', [13]: 'M', [14]: 'N', [15]: 'O', [16]: 'P', [17]: 'Q', [18]: 'R', [19]: 'S', [20]: 'T', [21]: 'U', [22]: 'V', [23]: 'W', [24]: 'X', [25]: 'Y', [26]: 'Z' }
---@field upper_map { A: 'A', B: 'B', C: 'C', D: 'D', E: 'E', F: 'F', G: 'G', H: 'H', I: 'I', J: 'J', K: 'K', L: 'L', M: 'M', N: 'N', O: 'O', P: 'P', Q: 'Q', R: 'R', S: 'S', T: 'T', U: 'U', V: 'V', W: 'W', X: 'X', Y: 'Y', Z: 'Z' }
---@field vowels User.Util.String.Alphabet.Vowels

---@class User.Util.String
---@field alphabet User.Util.String.Alphabet
---@field digits User.Util.String.Digits
local M = {
  alphabet = {
    lower_list = {
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
    },
    lower_map = {
      a = 'a',
      b = 'b',
      c = 'c',
      d = 'd',
      e = 'e',
      f = 'f',
      g = 'g',
      h = 'h',
      i = 'i',
      j = 'j',
      k = 'k',
      l = 'l',
      m = 'm',
      n = 'n',
      o = 'o',
      p = 'p',
      q = 'q',
      r = 'r',
      s = 's',
      t = 't',
      u = 'u',
      v = 'v',
      w = 'w',
      x = 'x',
      y = 'y',
      z = 'z',
    },
    upper_list = {
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
    },
    upper_map = {
      A = 'A',
      B = 'B',
      C = 'C',
      D = 'D',
      E = 'E',
      F = 'F',
      G = 'G',
      H = 'H',
      I = 'I',
      J = 'J',
      K = 'K',
      L = 'L',
      M = 'M',
      N = 'N',
      O = 'O',
      P = 'P',
      Q = 'Q',
      R = 'R',
      S = 'S',
      T = 'T',
      U = 'U',
      V = 'V',
      W = 'W',
      X = 'X',
      Y = 'Y',
      Z = 'Z',
    },
    vowels = {
      lower_list = { 'a', 'e', 'i', 'o', 'u' },
      lower_map = { a = 'a', e = 'e', i = 'i', o = 'o', u = 'u' },
      upper_list = { 'A', 'E', 'I', 'O', 'U' },
      upper_map = { A = 'A', E = 'E', I = 'I', O = 'O', U = 'U' },
    },
  },
  digits = {
    all = {
      ['0'] = '0',
      ['1'] = '1',
      ['2'] = '2',
      ['3'] = '3',
      ['4'] = '4',
      ['5'] = '5',
      ['6'] = '6',
      ['7'] = '7',
      ['8'] = '8',
      ['9'] = '9',
    },
    even_list = { '0', '2', '4', '6', '8' },
    even_map = { ['0'] = '0', ['2'] = '2', ['4'] = '4', ['6'] = '6', ['8'] = '8' },
    odd_list = { '1', '3', '5', '7', '9' },
    odd_map = { ['1'] = '1', ['3'] = '3', ['5'] = '5', ['7'] = '7', ['9'] = '9' },
  },
}

setmetatable(M, {
  __newindex = function()
    vim.notify('User.Util.String is Read-Only!', vim.log.levels.ERROR)
  end,
})

---@param str string
---@param use_dot? boolean
---@param triggers? string[]
---@return string new_str
function M.capitalize(str, use_dot, triggers)
  require('user_api.check').validate({
    str = { str, { 'string' } },
    use_dot = { use_dot, { 'boolean', 'nil' }, true },
    triggers = { triggers, { 'table', 'nil' }, true },
  })
  if str == '' then
    return str
  end
  if use_dot == nil then
    use_dot = false
  end
  triggers = vim.tbl_deep_extend('force', triggers or {}, { ' ', '' })

  local prev_char, new_str, i = '', '', 1
  local dot = true
  while i <= str:len() do
    local char = str:sub(i, i)
    if char == char:lower() and vim.list_contains(triggers, prev_char) then
      char = (dot and string.upper or string.lower)(char)
      if dot then
        dot = false
      end
    else
      char = char:lower()
    end

    if use_dot and not dot then
      dot = char == '.'
    elseif not use_dot then
      dot = true
    end

    new_str, prev_char, i = new_str .. char, char, i + 1
  end
  return new_str
end

---@param str string
---@param target string
---@param new string
---@return string new_str
function M.replace(str, target, new)
  require('user_api.check').validate({
    str = { str, { 'string' } },
    target = { target, { 'string' } },
    new = { new, { 'string' } },
  })

  if not vim.list_contains({ str, target, new }, '') and new ~= target then
    local new_str = ''
    for i = 1, str:len() do
      new_str = ('%s%s'):format(new_str, str:sub(i, i) == target and new or str:sub(i, i))
    end
    str = new_str
  end
  return str
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
