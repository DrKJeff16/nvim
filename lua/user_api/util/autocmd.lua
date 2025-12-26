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

---@class User.Util.Autocmd
---@field created? AuRepeatEvents[]
local M = {
  au_pair = function(T) ---@param T AuPair
    local type_not_empty = require('user_api.check.value').type_not_empty
    if not type_not_empty('table', T) then
      error('(user_api.util.au.au_pair): Not a table, or empty table', ERROR)
    end
    if not (type_not_empty('string', T.event) or type_not_empty('table', T.event)) then
      error('(user_api.util.au.au_pair): Event is neither a string nor a table', ERROR)
    end

    vim.api.nvim_create_autocmd(T.event, T.opts)
  end,

  ---@param T AuList
  au_from_arr = function(T)
    local type_not_empty = require('user_api.check.value').type_not_empty
    if not type_not_empty('table', T) then
      vim.notify('(user_api.util.au.au_from_arr): Not a table', ERROR)
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
          '(user_api.util.au.au_from_arr): Event is neither a string nor a table, skipping',
          ERROR
        )
      end

      vim.api.nvim_create_autocmd(v.event, v.opts)
    end
  end,
  au_from_dict = function(T) ---@param T AuDict
    local Value = require('user_api.check.value')
    if not Value.type_not_empty('table', T) then
      vim.notify('(user_api.util.au.au_from_arr): Not a table', ERROR)
      return
    end

    for k, v in pairs(T) do
      if not (Value.is_str(k) and Value.type_not_empty('table', v)) then
        error('(user_api.util.au.au_from_arr): Dictionary key is not a string, skipping', ERROR)
      end

      vim.api.nvim_create_autocmd(k, v)
    end
  end,
  au_repeated = function(T) ---@param T AuRepeat
    local Value = require('user_api.check.value')
    if not Value.type_not_empty('table', T) then
      vim.notify('(user_api.util.au.au_repeated): Param is not a valid table', ERROR)
      return
    end
    for event, t in pairs(T) do
      if not Value.is_str(event) then
        vim.notify('(user_api.util.au.au_repeated): Event is not a string, skipping', ERROR)
        return
      end
      if not Value.type_not_empty('table', t) then
        vim.notify('(user_api.util.au.au_repeated): Invalid options table, skipping', ERROR)
        return
      end
      for _, opts in ipairs(t) do
        if not Value.type_not_empty('table', opts) then
          vim.notify('(user_api.util.au.au_repeated): Option table is empty, skipping', ERROR)
          return
        end

        vim.api.nvim_create_autocmd(event, opts)
      end
    end
  end,
  au_repeated_events = function(T) ---@param T AuRepeatEvents
    local type_not_empty = require('user_api.check.value').type_not_empty
    if not type_not_empty('table', T) then
      vim.notify('(user_api.util.au.au_repeated_events): Not a valid table', ERROR)
      return
    end
    if not (type_not_empty('table', T.events) and type_not_empty('table', T.opts_tbl)) then
      vim.notify('(user_api.util.au.au_repeated_events): Invalid autocmd tables', WARN)
      return
    end

    for _, opts in ipairs(T.opts_tbl) do
      if not type_not_empty('table', opts) then
        vim.notify('(user_api.util.au.au_repeated_events): Options are not a vaild table', ERROR)
        return
      end
      vim.api.nvim_create_autocmd(T.events, opts)
    end
  end,
}

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
