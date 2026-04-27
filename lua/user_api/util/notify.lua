---@module 'notify'

---@enum (key) NotifyLvl
local lvls = {
  debug = vim.log.levels.DEBUG,
  error = vim.log.levels.ERROR,
  info = vim.log.levels.INFO,
  off = vim.log.levels.OFF,
  trace = vim.log.levels.TRACE,
  warn = vim.log.levels.WARN,
}

---@class NotifyOpts
---@field title? string Defaults to `'Message'`
---@field icon? string
---@field timeout? integer|boolean Defaults to `700`
---@field on_open? function
---@field on_close? fun(...)
---@field keep? fun(...)
---@field render? string|fun(...)
---@field replace? integer
---@field hide_from_history? boolean Defaults to `false`
---@field animate? boolean Defaults to `true`

local TRACE = lvls.trace
local DEBUG = lvls.debug
local INFO = lvls.info
local WARN = lvls.warn
local ERROR = lvls.error
local OFF = lvls.off
local validate = require('user_api.check').validate

---Can't use `user_api.check.exists.module()` here as said module might
---end up requiring this module, so let's avoid an import loop,
---shall we?
--- ---
---@param mod string The module `require()` string.
---@return boolean ok Whether the module exists.
local function exists(mod)
  local ok = pcall(require, mod)
  return ok
end

---@class User.Util.Notify
---@field opts notify.Options
local M = {}

---@diagnostic disable-next-line:missing-fields
M.opts = {
  animate = false,
  hide_from_history = false,
  title = 'Message',
  timeout = 1000,
  -- icon = '',
  -- render = '',
  -- replace = 1,
  -- on_open = function() end,
  -- on_close = function() end,
  -- keep = function() end,
}

---@enum (key) User.Util.Notify.Levels
M.Levels = {
  [TRACE] = 'trace',
  [DEBUG] = 'debug',
  [INFO] = 'info',
  [WARN] = 'warn',
  [ERROR] = 'error',
  [OFF] = 'off',
  TRACE = TRACE,
  DEBUG = DEBUG,
  INFO = INFO,
  WARN = WARN,
  ERROR = ERROR,
  OFF = OFF,
}

---@param msg string
---@param lvl? NotifyLvl|vim.log.levels
---@param opts? notify.Options
function M.notify(msg, lvl, opts)
  validate({
    msg = { msg, { 'string' } },
    lvl = { lvl, { 'string', 'number', 'nil' }, true },
    opts = { opts, { 'table', 'nil' }, true },
  })
  lvl = lvl or 'info'
  lvl = (not vim.tbl_contains({ 'string', 'number' }, type(lvl))) and 'info' or lvl
  opts = opts or M.opts

  if exists('notify') then
    if type(lvl) == 'number' then
      lvl = math.floor(lvl)
      lvl = (lvl <= OFF and lvl >= TRACE) and M.Levels[lvl] or M.Levels[INFO]
    elseif not vim.tbl_contains(M.Levels, lvl:lower()) then
      lvl = M.Levels[INFO]
    end

    opts = vim.tbl_deep_extend('keep', opts, M.opts)
  else
    if type(lvl) == 'string' then
      if vim.tbl_contains(M.Levels, lvl:lower()) then
        lvl = M.Levels[lvl:upper()]
      end
    elseif type(lvl) == 'number' then
      if lvl < TRACE or lvl > OFF then
        lvl = INFO
      end
    else
      lvl = INFO
    end
  end
  vim.notify(msg, lvl, opts)
end

---@param lvl vim.log.levels
---@return fun(args: vim.api.keyset.create_user_command.command_args)
local function gen_cmd_lvl(lvl)
  validate({ lvl = { lvl, { 'number' } } })

  return function(args) ---@param args vim.api.keyset.create_user_command.command_args
    local data = args.args
    if data == '' then
      return
    end
    local opts = {
      animate = true,
      title = 'Message',
      timeout = 1750,
      hide_from_history = args.bang,
    }
    M.notify(data, lvl, opts)
  end
end

vim.api.nvim_create_user_command('Notify', gen_cmd_lvl(INFO), {
  bang = true,
  nargs = '+',
  force = true,
})
vim.api.nvim_create_user_command('NotifyInfo', gen_cmd_lvl(INFO), {
  bang = true,
  nargs = '+',
  force = true,
})
vim.api.nvim_create_user_command('NotifyWarn', gen_cmd_lvl(WARN), {
  bang = true,
  nargs = '+',
  force = true,
})
vim.api.nvim_create_user_command('NotifyError', gen_cmd_lvl(ERROR), {
  bang = true,
  nargs = '+',
  force = true,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
