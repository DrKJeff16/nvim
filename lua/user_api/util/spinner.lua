local validate = require('user_api.check').validate

---@return boolean has
local function has_spinner()
  return package.loaded['spinner'] ~= nil or (pcall(require, 'spinner'))
end

---@class SpinnerObj
---@field id string
local O = {}
O.__index = O

function O:fail()
  if has_spinner() then
    require('spinner').fail(self.id)
  end
end

function O:pause()
  if has_spinner() then
    require('spinner').pause(self.id)
  end
end

function O:render()
  if has_spinner() then
    require('spinner').render(self.id)
  end
end

function O:reset()
  if has_spinner() then
    require('spinner').reset(self.id)
  end
end

function O:start()
  if has_spinner() then
    require('spinner').start(self.id)
  end
end

---@param force boolean
---@overload fun(self: SpinnerObj)
function O:stop(force)
  if has_spinner() then
    validate({ force = { force, { 'boolean', 'nil' }, true } })
    if force == nil then
      force = false
    end

    require('spinner').stop(self.id, force)
  end
end

---@class User.Util.Spinner
local M = {}

---@param id string
---@param opts spinner.Opts
---@return SpinnerObj|nil|? spinner
function M.new(id, opts)
  validate({
    id = { id, { 'string' } },
    opts = { opts, { 'table' } },
  })

  if has_spinner() then
    require('spinner').config(id, opts)

    local spinner = { id = id }
    setmetatable(spinner, O)
    return spinner
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
