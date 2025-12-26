---@module 'notify'

---@alias VimNotifyLvl vim.log.levels
---@alias NotifyLvl 'debug'|'error'|'info'|'off'|'trace'|'warn'

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

local TRACE = vim.log.levels.TRACE -- `0`
local DEBUG = vim.log.levels.DEBUG -- `1`
local INFO = vim.log.levels.INFO -- `2`
local WARN = vim.log.levels.WARN -- `3`
local ERROR = vim.log.levels.ERROR -- `4`
local OFF = vim.log.levels.OFF -- `5`

--- Can't use `user_api.check.exists.module()` here as said module might
--- end up requiring this module, so let's avoid an import loop,
--- shall we?
---@param mod string The module `require()` string
---@return boolean ok Whether the module exists
local function exists(mod)
  local ok, _ = pcall(require, mod)
  return ok
end

---@class User.Util.Notify
local Notify = {}

---@type notify.Options
---@diagnostic disable-next-line:missing-fields
Notify.Opts = {
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

---@class User.Util.Notify.Levels
Notify.Levels = {
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
---@param lvl? NotifyLvl|VimNotifyLvl
---@param opts? notify.Options
function Notify.notify(msg, lvl, opts)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('msg', msg, { 'string' }, false)
    vim.validate('lvl', lvl, { 'string', 'number', 'nil' }, true)
    vim.validate('opts', opts, { 'table', 'nil' }, true)
  else
    vim.validate({
      msg = { msg, { 'string' } },
      lvl = { lvl, { 'string', 'number', 'nil' }, true },
      opts = { opts, { 'table', 'nil' }, true },
    })
  end
  lvl = lvl or 'info'
  lvl = (not vim.tbl_contains({ 'string', 'number' }, type(lvl))) and 'info' or lvl
  opts = opts or Notify.Opts

  if exists('notify') then
    if type(lvl) == 'number' then
      lvl = math.floor(lvl)
      lvl = (lvl <= OFF and lvl >= TRACE) and Notify.Levels[lvl] or Notify.Levels[INFO]
    elseif not vim.tbl_contains(Notify.Levels, lvl:lower()) then
      lvl = Notify.Levels[INFO]
    end

    opts = vim.tbl_deep_extend('keep', opts, Notify.Opts)
  else
    if type(lvl) == 'string' then
      if vim.tbl_contains(Notify.Levels, lvl:lower()) then
        lvl = Notify.Levels[lvl:upper()]
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

---@param lvl VimNotifyLvl
---@return fun(args: vim.api.keyset.create_user_command.command_args)
local function gen_cmd_lvl(lvl)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('lvl', lvl, { 'number' }, false)
  else
    vim.validate({ lvl = { lvl, { 'number' } } })
  end

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
    Notify.notify(data, lvl, opts)
  end
end

vim.api.nvim_create_user_command('Notify', gen_cmd_lvl(vim.log.levels.INFO), {
  bang = true,
  nargs = '+',
  force = true,
})
vim.api.nvim_create_user_command('NotifyInfo', gen_cmd_lvl(vim.log.levels.INFO), {
  bang = true,
  nargs = '+',
  force = true,
})
vim.api.nvim_create_user_command('NotifyWarn', gen_cmd_lvl(vim.log.levels.WARN), {
  bang = true,
  nargs = '+',
  force = true,
})
vim.api.nvim_create_user_command('NotifyError', gen_cmd_lvl(vim.log.levels.ERROR), {
  bang = true,
  nargs = '+',
  force = true,
})

local M = setmetatable(Notify, { ---@type User.Util.Notify
  __index = Notify,
  __newindex = function()
    vim.notify('User.Util.Notify is Read-Only!', ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
