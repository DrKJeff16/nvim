---@class AuPair
---@field event string[]|string
---@field opts vim.api.keyset.create_autocmd

---@class AuRepeatEvents
---@field events string[]
---@field opts_tbl vim.api.keyset.create_autocmd[]

---@alias AuDict table<string, vim.api.keyset.create_autocmd>
---@alias AuRepeat table<string, vim.api.keyset.create_autocmd[]>
---@alias AuList AuPair[]

local validate = require('user_api.check').validate

---@class User.Util.Autocmd
local M = {}

---@overload fun(names: string): augroups: table<string, integer>
---@overload fun(names: string, clear: boolean): augroups: table<string, integer>
---@overload fun(names: { [1]: string, [2]?: boolean }[]): augroups: table<string, integer>
function M.gen_augroups(names, clear)
  validate({
    names = { names, { 'string', 'table' } },
    clear = { clear, { 'boolean', 'nil' }, true },
  })

  local augroups = {} ---@type table<string, integer>
  if type(names) == 'table' then
    for _, name in ipairs(names) do
      augroups[name] = vim.api.nvim_create_augroup(name[1], { clear = name[2] })
    end
  else
    if clear == nil then
      clear = true
    end
    augroups = { [names] = vim.api.nvim_create_augroup(names, { clear = clear }) }
  end
  return augroups
end

---@param T AuPair
function M.au_pair(T)
  validate({
    T = { T, { 'table' } },
    ['T.event'] = { T.event, { 'string', 'table' } },
    ['T.opts'] = { T.opts, { 'table' } },
  })

  vim.api.nvim_create_autocmd(T.event, T.opts)
end

---@param T AuList
function M.au_from_arr(T)
  validate({ T = { T, { 'table' } } })
  assert(vim.islist(T), '(user_api.util.autocmd.au_from_arr): Table is not list-like')

  for _, v in ipairs(T) do
    M.au_pair(v)
  end
end

---@param T AuDict
function M.au_from_dict(T)
  validate({ T = { T, { 'table' } } })

  for k, v in pairs(T) do
    M.au_pair({ event = k, opts = v })
  end
end

---@param T AuRepeat
function M.au_repeated(T)
  validate({ T = { T, { 'table' } } })

  for event, t in pairs(T) do
    validate({ t = { t, { 'table' } } })

    for _, opts in ipairs(t) do
      M.au_pair({ event = event, opts = opts })
    end
  end
end

---@param T AuRepeatEvents[]|AuRepeatEvents
function M.au_repeated_events(T)
  validate({ T = { T, { 'table' } } })
  assert(not vim.tbl_isempty(T), '(user_api.util.au.au_repeated_events): Not a valid table')

  if vim.islist(T) then
    for _, au in ipairs(T) do
      M.au_repeated_events(au)
    end
  elseif T.events and T.opts_tbl then
    validate({ ['T.opts_tbl'] = { T.opts_tbl, { 'table' } } })

    for _, opts in ipairs(T.opts_tbl) do
      M.au_pair({ event = T.events, opts = opts })
    end
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
