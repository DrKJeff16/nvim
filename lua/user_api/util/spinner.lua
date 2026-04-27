local validate = require('user_api.check').validate

---@class SpinnerObj
---@field id string
local O = {}
O.__index = O

function O:fail()
  require('spinner').fail(self.id)
end

function O:pause()
  require('spinner').pause(self.id)
end

function O:render()
  require('spinner').render(self.id)
end

function O:reset()
  require('spinner').reset(self.id)
end

function O:start()
  require('spinner').start(self.id)
end

---@param force? boolean
function O:stop(force)
  validate({ force = { force, { 'boolean', 'nil' }, true } })
  if force == nil then
    force = false
  end

  require('spinner').stop(self.id, force)
end

---@class User.Util.Spinner
local M = {}

---@param id string
---@param opts spinner.Opts
---@return SpinnerObj spinner
function M.new(id, opts)
  validate({
    id = { id, { 'string' } },
    opts = { opts, { 'table' } },
  })

  require('spinner').config(id, opts)

  return setmetatable({ id = id }, O)
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
