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
---@param verbose? boolean
function M.new_picker(mod, name, spec, verbose)
  validate({
    mod = { mod, { 'string' } },
    name = { name, { 'string' } },
    spec = { spec, { 'table' } },
    ['spec.mod'] = { spec.mod, { 'string' } },
    ['spec.cb'] = { spec.cb, { 'function' } },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  if verbose == nil then
    verbose = false
  end

  if exists(mod) then
    pickers[name] = P:new(spec)

    if verbose then
      vim.notify(('(User API): Added the `%s` picker'):format(name), vim.log.levels.INFO)
    end
  end
end

---@param verbose? boolean
function M.setup(verbose)
  validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
  if verbose == nil then
    verbose = false
  end

  local Pickers = { ---@type table<string, { [1]: string , [2]: User.Pickers.Spec, [3]?: boolean }>
    ['telescope.init'] = {
      'telescope',
      {
        mod = 'telescope._extensions.picker_list',
        cb = function()
          require('telescope._extensions.picker_list').exports.picker_list()
        end,
      },
    },
    snacks = {
      'snacks.nvim',
      {
        mod = 'snacks.picker',
        cb = function()
          require('snacks.picker').pickers({
            auto_close = true,
            auto_confirm = false,
            cwd = vim.uv.cwd() or vim.fn.getcwd(),
            enter = true,
            focus = 'list',
            show_empty = false,
            ui_select = true,
          })
        end,
      },
    },
    ['fzf-lua'] = {
      'fzf-lua',
      {
        mod = 'fzf-lua.cmd',
        cb = function()
          require('fzf-lua.cmd').run_command('builtin')
        end,
      },
    },
    picker = {
      'picker.nvim',
      {
        mod = 'picker',
        cb = function()
          require('picker').open({})
        end,
      },
    },
  }

  table.sort(Pickers, function(a, b)
    return a[1] < b[1]
  end)

  for mod, args in pairs(Pickers) do
    M.new_picker(mod, args[1], args[2], args[3])
  end
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
