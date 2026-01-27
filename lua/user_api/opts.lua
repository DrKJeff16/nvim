local MODSTR = 'user_api.opts'
local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO
local in_list = vim.list_contains
local curr_buf = vim.api.nvim_get_current_buf

---@class User.Opts
local Opts = {}

Opts.options = {} ---@type User.Opts.Spec

---@return User.Opts.AllOpts all_opts
function Opts.get_all_opts()
  return require('user_api.opts.all_opts')
end

---@return User.Opts.Spec defaults
function Opts.get_defaults()
  return require('user_api.opts.config')
end

---@param ArgLead string
---@param CursorPos integer
---@return string[] items
local function toggle_completer(ArgLead, _, CursorPos)
  local len = ArgLead:len()
  local CMD_LEN = ('OptsToggle '):len() + 1
  if len == 0 or CursorPos < CMD_LEN then
    return Opts.toggleable
  end

  local valid = {} ---@type string[]
  for _, o in ipairs(Opts.toggleable) do
    if o:match(ArgLead) ~= nil and o:find('^' .. ArgLead) then
      table.insert(valid, o)
    end
  end
  return valid
end

---@return string[] valid
function Opts.gen_toggleable()
  local valid = {} ---@type string[]
  local T = Opts.get_all_opts()
  local long, short = vim.tbl_keys(T), vim.tbl_values(T) ---@type string[], string[]
  for _, opt_type in ipairs({ long, short }) do
    for _, opt in ipairs(opt_type) do
      if opt ~= '' and in_list({ 'no', 'yes', true, false }, vim.o[opt]) then
        table.insert(valid, opt)
      end
    end
  end

  table.sort(valid)
  return valid
end

Opts.toggleable = Opts.gen_toggleable()

---@param T User.Opts.Spec
---@param verbose boolean
---@return User.Opts.Spec parsed_opts
---@overload fun(T: User.Opts.Spec): parsed_opts: User.Opts.Spec
function Opts.long_opts_convert(T, verbose)
  require('user_api.check.exists').validate({
    T = { T, { 'table' } },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  verbose = verbose ~= nil and verbose or false

  local Value = require('user_api.check.value')
  local parsed_opts = {} ---@type User.Opts.Spec
  local msg, verb_msg = '', ''
  if not Value.type_not_empty('table', T) then
    if verbose then
      vim.notify('(user.opts.long_opts_convert): All seems good', INFO)
    end
    return parsed_opts
  end

  local ALL_OPTIONS = Opts.get_all_opts()
  local keys = vim.tbl_keys(ALL_OPTIONS) ---@type string[]
  table.sort(keys)
  for opt, val in pairs(T) do
    if in_list(keys, opt) then
      parsed_opts[opt] = val
    elseif not Value.tbl_values({ opt }, ALL_OPTIONS) then
      -- If neither long nor short (known) option, append to warning message
      msg = ('%s- Option `%s` not valid!\n'):format(msg, opt)
    else
      local new_opt = Value.tbl_values({ opt }, ALL_OPTIONS, true)
      if Value.is_str(new_opt) and new_opt ~= '' then
        parsed_opts[new_opt] = val
        verb_msg = ('%s%s ==> %s\n'):format(verb_msg, opt, new_opt)
      else
        msg = ('%s- Option `%s` non valid!\n'):format(msg, new_opt)
      end
    end
  end

  if msg ~= '' then
    vim.notify(msg, ERROR)
  elseif verbose and verb_msg ~= '' then
    vim.notify(verb_msg, INFO)
  end
  return parsed_opts
end

---Option setter for the aforementioned options dictionary.
--- ---
---@param O User.Opts.Spec A dictionary with keys acting as `vim.o` fields, and values
---@param verbose boolean Enable verbose printing if `true`
---@overload fun(O: User.Opts.Spec)
function Opts.optset(O, verbose)
  require('user_api.check.exists').validate({
    O = { O, { 'table' } },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  verbose = verbose ~= nil and verbose or false
  if not vim.api.nvim_get_option_value('modifiable', { buf = curr_buf() }) then
    return
  end

  local msg, verb_msg = '', ''
  local opts = Opts.long_opts_convert(O, verbose)
  for k, v in pairs(opts) do
    if type(vim.o[k]) == type(v) then
      Opts.options[k] = v
      vim.o[k] = Opts.options[k]
      verb_msg = ('%s- %s: %s\n'):format(verb_msg, k, vim.inspect(v))
    end
  end
  if msg ~= '' then
    vim.notify(msg, ERROR)
    return
  end
  if verbose then
    vim.notify(verb_msg, INFO)
  end
end

---Set up `guicursor` so that cursor blinks.
--- ---
function Opts.set_cursor_blink()
  if require('user_api.check').in_console() then
    return
  end
  Opts.optset({
    guicursor = 'n-v-c:block'
      .. ',i-ci-ve:ver25'
      .. ',r-cr:hor20'
      .. ',o:hor50'
      .. ',a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'
      .. ',sm:block-blinkwait175-blinkoff150-blinkon175',
  })
end

function Opts.print_set_opts()
  local T = vim.deepcopy(Opts.options)
  table.sort(T)
  vim.notify(vim.inspect(T), INFO)
end

---@param O string[]|string
---@param verbose boolean
---@overload fun(O: string)
---@overload fun(O: string[])
---@overload fun(O: string, verbose: boolean)
---@overload fun(O: string[], verbose: boolean)
function Opts.toggle(O, verbose)
  require('user_api.check.exists').validate({
    O = { O, { 'string', 'table' } },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  verbose = verbose ~= nil and verbose or false

  local Value = require('user_api.check.value')

  ---@cast O string
  if Value.is_str(O) then
    O = { O }
  end

  ---@cast O string[]
  if vim.tbl_isempty(O) then
    return
  end
  for _, opt in ipairs(O) do
    if in_list(Opts.toggleable, opt) then
      local value = vim.o[opt]
      if Value.is_bool(value) then
        value = not value
      else
        value = value == 'yes' and 'no' or 'yes'
      end
      Opts.optset({ [opt] = value }, verbose)
    end
  end
end

function Opts.setup_cmds()
  local Commands = require('user_api.commands')
  Commands.add_command('OptsToggle', function(ctx)
    local cmds = {}
    for _, v in ipairs(ctx.fargs) do
      if not (in_list(Opts.toggleable, v) or ctx.bang) then
        vim.notify(('(OptsToggle): Cannot toggle option `%s`, aborting'):format(v), ERROR)
        return
      end
      if in_list(Opts.toggleable, v) and not in_list(cmds, v) then
        table.insert(cmds, v)
      end
    end
    Opts.toggle(cmds, ctx.bang)
  end, { nargs = '+', complete = toggle_completer, bang = true, desc = 'Toggle Vim Options' })
  Commands.add_command('OptsToggleable', function()
    local msg = ''
    for i, v in ipairs(Opts.toggleable) do
      msg = ('%s%s%s'):format(msg, i == 1 and '' or '\n', v)
    end
    vim.print(msg)
  end, { desc = 'Print all toggleable options' })
end

function Opts.setup_maps()
  local desc = require('user_api.maps').desc
  require('user_api.config').keymaps.set({
    n = {
      ['<leader>UO'] = { group = '+Options' },
      ['<leader>UOl'] = { Opts.print_set_opts, desc('Print options set by `user.opts`') },
      ['<leader>UOT'] = { ':OptsToggle ', desc('Prompt To Toggle Opts', false) },
    },
  })
end

---@param override User.Opts.Spec A table with custom options
---@param verbose boolean Flag to make the function return a string with invalid values, if any
---@param cursor_blink boolean Whether to enable cursor blinking
---@overload fun()
---@overload fun(override: User.Opts.Spec)
---@overload fun(override: User.Opts.Spec, verbose: boolean)
function Opts.setup(override, verbose, cursor_blink)
  require('user_api.check.exists').validate({
    override = { override, { 'table', 'nil' }, true },
    verbose = { verbose, { 'boolean', 'nil' }, true },
    cursor_blink = { cursor_blink, { 'boolean', 'nil' }, true },
  })
  verbose = verbose ~= nil and verbose or false
  cursor_blink = cursor_blink ~= nil and cursor_blink or false

  if vim.tbl_isempty(Opts.options) then
    Opts.options = Opts.long_opts_convert(Opts.get_defaults(), verbose)
  end

  local parsed_opts = Opts.long_opts_convert(override or {}, verbose)
  Opts.options = vim.tbl_deep_extend('keep', parsed_opts, Opts.options) ---@type vim.bo|vim.wo
  Opts.optset(Opts.options, verbose)

  if cursor_blink then
    Opts.set_cursor_blink()
  end
end

local M = setmetatable(Opts, { ---@type User.Opts
  __index = Opts,
  __newindex = function()
    vim.notify(('(%s): This module is read only!'):format(MODSTR), ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
