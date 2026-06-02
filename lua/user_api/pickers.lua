---@class (exact) User.Pickers.Spec
---@field mod string
---@field cb function

local validate = require('user_api.check').validate
local exists = require('user_api.check').module

---@class User.Pickers.Entry
---@field mod string
local P = {}

---@param spec User.Pickers.Spec
---@return User.Pickers.Entry|function entry
function P:new(spec)
  validate({
    spec = { spec, { 'table' } },
    ['spec.mod'] = { spec.mod, { 'string' } },
    ['spec.cb'] = { spec.cb, { 'function' } },
  })

  return setmetatable({ mod = spec.mod }, {
    __index = self,
    __call = function()
      spec.cb()
    end,
  })
end

local pickers = {} ---@type table<string, User.Pickers.Entry|function>

---@class User.Pickers
local M = {}

---@param mod string
---@param name string
---@param spec User.Pickers.Spec
function M.new_picker(mod, name, spec)
  validate({
    mod = { mod, { 'string' } },
    name = { name, { 'string' } },
    spec = { spec, { 'table' } },
    ['spec.mod'] = { spec.mod, { 'string' } },
    ['spec.cb'] = { spec.cb, { 'function' } },
  })

  if not exists(mod) then
    return
  end

  pickers[name] = P:new(spec)
end

function M.setup()
  M.new_picker('telescope', 'telescope', {
    mod = 'telescope._extensions.picker_list',
    cb = require('telescope._extensions.picker_list').exports.picker_list,
  })
  M.new_picker('snacks', 'snacks.nvim', {
    mod = 'snacks.picker',
    cb = require('snacks.picker').pickers,
  })
  M.new_picker('fzf-lua', 'fzf-lua', {
    mod = 'fzf-lua.cmd',
    cb = require('fzf-lua.cmd').run_command,
  })
  M.new_picker('picker', 'picker.nvim', {
    mod = 'picker',
    cb = function()
      require('picker').open({})
    end,
  })
end

function M.run()
  for name, picker in ipairs(pickers) do
    if not exists(picker.mod) then
      pickers[name] = nil
    end
  end

  local keys = vim.tbl_keys(pickers) --[[@as string[]\]]
  vim.ui.select(keys, { prompt = 'Select The Desired Picker' }, function(item) ---@param item string
    if not (item and vim.list_contains(keys, item)) then
      return
    end

    pcall(pickers[item])
  end)
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
