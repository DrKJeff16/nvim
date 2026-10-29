---@module 'snacks'

---@class (exact) User.Pickers.Spec
---@field cb function
---@field mod string

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

  local entry = { mod = spec.mod } ---@type User.Pickers.Entry|function
  setmetatable(entry, {
    __call = function()
      spec.cb()
    end,
  })
  return entry
end

local pickers = {} ---@type table<string, User.Pickers.Entry|function>

---@class User.Pickers
local M = {}

---@param mod string
---@param name string
---@param spec User.Pickers.Spec
---@param verbose boolean
---@overload fun(mod: string, name: string, spec: User.Pickers.Spec)
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

  if package.loaded[mod] ~= nil then
    pickers[name] = P:new(spec)

    if verbose then
      vim.notify(('(User API): Added the `%s` picker'):format(name), vim.log.levels.INFO)
    end
  end
end

---@param verbose boolean
---@overload fun()
function M.setup(verbose)
  validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
  if verbose == nil then
    verbose = false
  end

  local Pickers = { ---@type table<string, { [1]: string , [2]: User.Pickers.Spec, [3]?: boolean }>
    ['telescope._extensions.picker_list'] = {
      'telescope',
      {
        cb = function()
          require('telescope._extensions.picker_list').exports.picker_list()
        end,
        mod = 'telescope._extensions.picker_list',
      },
    },
    snacks = {
      'snacks.nvim',
      {
        cb = function()
          _G.Snacks.picker.pickers({
            auto_close = true,
            auto_confirm = false,
            cwd = (vim.uv or vim.loop).cwd() or vim.fn.getcwd(),
            enter = true,
            focus = 'list',
            show_empty = false,
            ui_select = true,
          })
        end,
        mod = 'snacks.picker',
      },
    },
    ['fzf-lua'] = {
      'fzf-lua',
      {
        cb = function()
          require('fzf-lua.cmd').run_command('builtin')
        end,
        mod = 'fzf-lua.cmd',
      },
    },
    picker = {
      'picker.nvim',
      {
        cb = function()
          require('picker').open({})
        end,
        mod = 'picker',
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
    if picker.mod ~= '' and package.loaded[picker.mod] == nil then
      pickers[name] = nil
    end
  end

  local keys = vim.tbl_keys(pickers) --[[@as string[]\]]
  vim.ui.select(keys, { prompt = 'Select The Desired Picker' }, function(item) ---@param item string
    if not (item and vim.list_contains(keys, item)) then
      return
    end
    if item ~= 'Exit' then
      pcall(pickers[item])
    end
  end)
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
