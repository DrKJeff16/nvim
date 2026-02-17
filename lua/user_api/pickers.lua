---@alias User.Pickers.Spec { mod: string, cb: function }

---@class User.Pickers
local M = {}

M.pickers = {} ---@type table<string, User.Pickers.Spec>

---@param name string
---@param spec User.Pickers.Spec
function M.new_picker(name, spec)
  require('user_api.check').validate({
    name = { name, { 'string' } },
    spec = { spec, { 'table' } },
    ['spec.mod'] = { spec.mod, { 'string' } },
    ['spec.cb'] = { spec.cb, { 'function' } },
  })

  M.pickers[name] = spec
end

function M.setup()
  M.new_picker('telescope', {
    mod = 'telescope._extensions.picker_list',
    cb = function()
      require('telescope._extensions.picker_list').exports.picker_list()
    end,
  })

  M.new_picker('snacks.nvim', {
    mod = 'snacks.picker',
    cb = function()
      require('snacks.picker').pickers()
    end,
  })

  M.new_picker('fzf-lua', {
    mod = 'fzf-lua.cmd',
    cb = function()
      require('fzf-lua.cmd').run_command() ---@diagnostic disable-line:missing-parameter
    end,
  })

  M.new_picker('picker.nvim', {
    mod = 'picker',
    cb = function()
      require('picker').open({})
      vim.schedule(function()
        vim.api.nvim_feedkeys('i', 'n', false)
      end)
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
  table.sort(keys)

  vim.ui.select(keys, { prompt = 'Select The Desired Picker' }, function(item)
    if not item then
      return
    end
    if not vim.list_contains(keys, item) then
      vim.notify(('Invalid picker `%s`'):format(item), vim.log.levels.ERROR)
      return
    end

    pcall(M.pickers[item].cb)
  end)
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
