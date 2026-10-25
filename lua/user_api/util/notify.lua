---@module 'notify'

---@alias NotifyLvl
---|'debug'
---|'error'
---|'info'
---|'off'
---|'trace'
---|'warn'

---@class NotifyOpts: notify.Options
---@field animate? boolean Defaults to `true`
---@field hide_from_history? boolean Defaults to `false`
---@field icon? string
---@field keep? fun(...)
---@field on_close? fun(...)
---@field on_open? function
---@field render? string|fun(...)
---@field replace? integer
---@field timeout? integer|boolean Defaults to `700`
---@field title? string Defaults to `'Message'`

local TRACE = vim.log.levels.TRACE
local DEBUG = vim.log.levels.DEBUG
local INFO = vim.log.levels.INFO
local WARN = vim.log.levels.WARN
local ERROR = vim.log.levels.ERROR
local OFF = vim.log.levels.OFF
local validate = require('user_api.check').validate

---Can't use `user_api.check.exists.module()` here as said module might
---end up requiring this module, so let's avoid an import loop, shall we?
--- ---
---@param mod string The module `require()` string.
---@return boolean ok Whether the module exists.
local function exists(mod)
  validate({ mod = { mod, { 'string' } } })

  return package.loaded[mod] ~= nil
end

---@class User.Util.Notify
---@field opts NotifyOpts
local M = {}

M.opts = { animate = false, hide_from_history = false, title = 'Message', timeout = 1000 }

---@enum (key) User.Util.Notify.Levels
M.Levels = {
  DEBUG = DEBUG,
  ERROR = ERROR,
  INFO = INFO,
  OFF = OFF,
  TRACE = TRACE,
  WARN = WARN,
  [DEBUG] = 'debug',
  [ERROR] = 'error',
  [INFO] = 'info',
  [OFF] = 'off',
  [TRACE] = 'trace',
  [WARN] = 'warn',
}

---@param msg string
---@param lvl NotifyLvl|0|1|2|3|4|5
---@param opts NotifyOpts
---@overload fun(msg: string)
---@overload fun(msg: string, lvl: NotifyLvl|0|1|2|3|4|5)
---@overload fun(msg: string, lvl: nil, opts: NotifyOpts)
function M.notify(msg, lvl, opts)
  validate({
    msg = { msg, { 'string' } },
    lvl = { lvl, { 'string', 'number', 'nil' }, true },
    opts = { opts, { 'table', 'nil' }, true },
  })
  lvl = lvl or 'info'
  lvl = (not vim.list_contains({ 'string', 'number' }, type(lvl))) and 'info' or lvl
  opts = opts or M.opts

  if exists('notify') then
    if type(lvl) == 'number' then
      lvl = (math.floor(lvl) <= OFF and math.floor(lvl) >= TRACE) and M.Levels[math.floor(lvl)] or M.Levels[INFO]
    elseif not vim.tbl_contains(M.Levels, lvl:lower()) then
      lvl = M.Levels[INFO]
    end
    opts = vim.tbl_deep_extend('keep', opts, M.opts)
  else
    if type(lvl) == 'string' and vim.tbl_contains(M.Levels, lvl:lower()) then
      lvl = M.Levels[lvl:upper()]
    elseif type(lvl) == 'string' or (type(lvl) == 'number' and lvl < TRACE or lvl > OFF) then
      lvl = INFO
    end
  end
  vim.notify(msg, lvl, opts)
end

---@param lvl 0|1|2|3|4|5
---@return fun(args: vim.api.keyset.create_user_command.command_args)
local function gen_cmd_lvl(lvl)
  validate({ lvl = { lvl, { 'number' } } })

  return function(args) ---@param args vim.api.keyset.create_user_command.command_args
    M.notify(args.args, lvl, {
      animate = true,
      hide_from_history = args.bang,
      timeout = 1750,
      title = 'Message',
    })
  end
end

function M.setup()
  local Commands = require('user_api.commands')
  for cmd, lvl in pairs({ Notify = INFO, NotifyWarn = WARN, NotifyError = ERROR }) do
    Commands.add_command({ [cmd] = { callback = gen_cmd_lvl(lvl), opts = { bang = true, nargs = '+' } } })
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
