---@module 'snacks'

local DEBUG = vim.log.levels.DEBUG
local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO
local TRACE = vim.log.levels.TRACE
local WARN = vim.log.levels.WARN

---@param msg string
---@param sel any
---@param space? boolean
---@return string msg
local function format_sel(msg, sel, space)
  require('user_api.check').validate({
    msg = { msg, { 'string' } },
    space = { space, { 'boolean', 'nil' }, true },
  })
  if space == nil then
    space = true
  end

  if sel then
    if vim.list_contains({ 'number', 'boolean' }, type(sel)) then
      sel = tostring(sel)
    elseif type(sel) ~= 'string' then
      sel = vim.inspect(sel)
    end
    msg = ('%s%s%s'):format(msg, space and ' ' or '', sel)
  end
  return msg
end

---@param lvl 0|1|2|3|4
---@param ... any
return function(lvl, ...)
  require('user_api.check').validate({ lvl = { lvl, { 'number' } } })
  lvl = vim.list_contains({ DEBUG, INFO, WARN, TRACE, ERROR }, lvl) and lvl or INFO
  if not (require('user_api.check').module('snacks') and _G.Snacks) then
    return
  end

  local msg = ''
  for i = 1, select('#', ...) do
    msg = format_sel(msg, select(i, ...), i ~= 1)
  end

  pcall(_G.Snacks.debug.backtrace, msg, { history = true, style = 'fancy', title = 'User API' })
end
