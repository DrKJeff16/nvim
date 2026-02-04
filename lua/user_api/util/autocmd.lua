---@alias AuOpts vim.api.keyset.create_autocmd
---@alias AuGroupOpts vim.api.keyset.create_augroup

---@class AuPair
---@field event string[]|string
---@field opts AuOpts

---@class AuRepeatEvents
---@field events string[]
---@field opts_tbl AuOpts[]

---@alias AuDict table<string, AuOpts>
---@alias AuRepeat table<string, AuOpts[]>
---@alias AuList AuPair[]

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local MODSTR = 'user_api.util.au'

---@class User.Util.Autocmd
local M = {}

---@param names string[]|string
---@param clear? boolean
---@return table<string, integer> augroups
function M.gen_augroups(names, clear)
  require('user_api.check.exists').validate({
    names = { names, { 'string', 'table' } },
    clear = { clear, { 'boolean', 'nil' }, true },
  })
  clear = clear ~= nil and clear or true

  if require('user_api.check.value').is_tbl(names) and not vim.tbl_isempty(names) then
    ---@cast names string[]
    local augroups = {} ---@type table<string, integer>
    for _, name in ipairs(names) do
      augroups[name] = vim.api.nvim_create_augroup(name, { clear = clear })
    end
    return augroups
  end

  ---@cast names string
  return { [names] = vim.api.nvim_create_augroup(names, { clear = clear }) }
end

---@param T AuPair
function M.au_pair(T)
  local type_not_empty = require('user_api.check.value').type_not_empty
  if not type_not_empty('table', T) then
    error(('(%s.au_pair): Not a table, or empty table'):format(MODSTR), ERROR)
  end
  if not (type_not_empty('string', T.event) or type_not_empty('table', T.event)) then
    error(('(%s.au_pair): Event is neither a string nor a table'):format(MODSTR), ERROR)
  end

  vim.api.nvim_create_autocmd(T.event, T.opts)
end

---@param T AuList
function M.au_from_arr(T)
  local type_not_empty = require('user_api.check.value').type_not_empty
  if not type_not_empty('table', T) then
    vim.notify(('(%s.au_from_arr): Not a table'):format(MODSTR), ERROR)
    return
  end

  for _, v in ipairs(T) do
    if
      not (
        type_not_empty('string', v.event)
        or type_not_empty('table', v.event) and type_not_empty('table', v.opts)
      )
    then
      error(
        ('(%s.au_from_arr): Event is neither a string nor a table, skipping'):format(MODSTR),
        ERROR
      )
    end

    vim.api.nvim_create_autocmd(v.event, v.opts)
  end
end

---@param T AuDict
function M.au_from_dict(T)
  local Value = require('user_api.check.value')
  if not Value.type_not_empty('table', T) then
    vim.notify(('(%s.au_from_arr): Not a table'):format(MODSTR), ERROR)
    return
  end

  for k, v in pairs(T) do
    if not (Value.is_str(k) and Value.type_not_empty('table', v)) then
      error(('(%s.au_from_arr): Dictionary key is not a string, skipping'):format(MODSTR), ERROR)
    end

    vim.api.nvim_create_autocmd(k, v)
  end
end

---@param T AuRepeat
function M.au_repeated(T)
  local Value = require('user_api.check.value')
  if not Value.type_not_empty('table', T) then
    vim.notify(('(%s.au_repeated): Param is not a valid table'):format(MODSTR), ERROR)
    return
  end
  for event, t in pairs(T) do
    if not Value.is_str(event) then
      vim.notify(('(%s.au_repeated): Event is not a string, skipping'):format(MODSTR), ERROR)
      return
    end
    if not Value.type_not_empty('table', t) then
      vim.notify(('(%s.au_repeated): Invalid options table, skipping'):format(MODSTR), ERROR)
      return
    end
    for _, opts in ipairs(t) do
      if not Value.type_not_empty('table', opts) then
        vim.notify(('(%s.au_repeated): Option table is empty, skipping'):format(MODSTR), ERROR)
        return
      end

      vim.api.nvim_create_autocmd(event, opts)
    end
  end
end

---@param T AuRepeatEvents[]|AuRepeatEvents
function M.au_repeated_events(T)
  require('user_api.check.exists').validate({ T = { T, { 'table' } } })
  if vim.tbl_isempty(T) then
    vim.notify(('(%s.au_repeated_events): Not a valid table'):format(MODSTR), ERROR)
    return
  end

  if vim.islist(T) then
    ---@cast T AuRepeatEvents[]
    for _, au in ipairs(T) do
      M.au_repeated_events(au)
    end
  end

  ---@cast T AuRepeatEvents
  if vim.tbl_isempty(T.events) or vim.tbl_isempty(T.opts_tbl) then
    vim.notify(('(%s.au_repeated_events): Invalid autocmd tables'):format(MODSTR), WARN)
    return
  end

  for _, opts in ipairs(T.opts_tbl) do
    if not require('user_api.check.value').is_tbl(opts) or vim.tbl_isempty(opts) then
      vim.notify(('(%s.au_repeated_events): Options are not a vaild table'):format(MODSTR), ERROR)
      return
    end
    vim.api.nvim_create_autocmd(T.events, opts)
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
