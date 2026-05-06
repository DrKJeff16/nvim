---@class (exact) User.Pickers.Spec
---@field mod string
---@field cb function

local validate = require('user_api.check').validate

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

---@class User.Pickers
---@field pickers table<string, User.Pickers.Entry|function>
local M = {}

M.pickers = {}

---@param name string
---@param spec User.Pickers.Spec
function M.new_picker(name, spec)
  validate({
    name = { name, { 'string' } },
    spec = { spec, { 'table' } },
    ['spec.mod'] = { spec.mod, { 'string' } },
    ['spec.cb'] = { spec.cb, { 'function' } },
  })

  M.pickers[name] = P:new(spec)
end

function M.setup()
  M.new_picker('telescope', {
    mod = 'telescope._extensions.picker_list',
    cb = require('telescope._extensions.picker_list').exports.picker_list,
  })
  M.new_picker('snacks.nvim', {
    mod = 'snacks.picker',
    cb = require('snacks.picker').pickers,
  })
  M.new_picker('fzf-lua', {
    mod = 'fzf-lua.cmd',
    cb = require('fzf-lua.cmd').run_command,
  })
  M.new_picker('picker.nvim', {
    mod = 'picker',
    cb = function()
      require('picker').open({})
    end,
  })
end

function M.run()
  local exists = require('user_api.check.exists').module
  for name, picker in ipairs(M.pickers) do
    if not exists(picker.mod) then
      M.pickers[name] = nil
    end
  end

  local keys = vim.tbl_keys(M.pickers) ---@type string[]
  vim.ui.select(keys, { prompt = 'Select The Desired Picker' }, function(item) ---@param item string
    if not (item and vim.list_contains(keys, item)) then
      vim.notify(('Invalid picker `%s`'):format(item), vim.log.levels.ERROR)
      return
    end

    pcall(M.pickers[item])
  end)
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
