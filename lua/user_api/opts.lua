local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO
local in_list = vim.list_contains
local curr_buf = vim.api.nvim_get_current_buf
local validate = require('user_api.check').validate

---@class User.Opts
---@field all_opts User.Opts.AllOpts
---@field config User.Opts.Spec
---@field options User.Opts.Spec
local M = {}

M.options = {}

---@return User.Opts.AllOpts all_opts
function M.get_all_opts()
  return require('user_api.opts.all_opts')
end

---@return User.Opts.Spec defaults
function M.get_defaults()
  return require('user_api.opts.config')
end

---@param lead string
---@param pos integer
---@return string[] items
local function toggle_completer(lead, _, pos)
  local len = lead:len()
  local CMD_LEN = ('OptsToggle '):len() + 1
  if len == 0 or pos < CMD_LEN then
    return M.toggleable
  end

  local valid = {} ---@type string[]
  for _, o in ipairs(M.toggleable) do
    if o:match(lead) ~= nil and o:find('^' .. lead) then
      table.insert(valid, o)
    end
  end
  return valid
end

---@param short? boolean
---@return string[] valid
function M.gen_toggleable(short)
  validate({ short = { short, { 'boolean', 'nil' }, true } })
  if short == nil then
    short = false
  end

  local valid = {} ---@type string[]
  local T = M.get_all_opts()
  local o_long, o_short = vim.tbl_keys(T), vim.tbl_values(T) ---@type string[], string[]
  for _, opt in ipairs(o_long) do
    if opt ~= '' and in_list({ 'no', 'yes', true, false }, vim.o[opt]) then
      table.insert(valid, opt)
    end
  end
  if short then
    for _, opt in ipairs(o_short) do
      if opt ~= '' and in_list({ 'no', 'yes', true, false }, vim.o[opt]) then
        table.insert(valid, opt)
      end
    end
  end

  table.sort(valid)
  return valid
end

M.toggleable = M.gen_toggleable(true)

---@param T User.Opts.Spec
---@param verbose boolean
---@return User.Opts.Spec parsed_opts
---@overload fun(T: User.Opts.Spec): parsed_opts: User.Opts.Spec
function M.long_opts_convert(T, verbose)
  validate({
    T = { T, { 'table' } },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  if verbose == nil then
    verbose = false
  end

  local parsed_opts = {} ---@type User.Opts.Spec
  local msg, verb_msg = '', ''
  if not require('user_api.check').type_not_empty('table', T) then
    if verbose then
      vim.notify('(user.opts.long_opts_convert): All seems good', INFO)
    end
    return parsed_opts
  end

  local ALL_OPTIONS = M.get_all_opts()
  local keys = vim.tbl_keys(ALL_OPTIONS) ---@type string[]
  table.sort(keys)
  for opt, val in pairs(T) do
    if in_list(keys, opt) then
      parsed_opts[opt] = val
    elseif not require('user_api.check').tbl_values({ opt }, ALL_OPTIONS) then
      -- If neither long nor short (known) option, append to warning message
      msg = ('%s- Option `%s` not valid!\n'):format(msg, opt)
    else
      local new_opt = require('user_api.check').tbl_values({ opt }, ALL_OPTIONS, true)
      if require('user_api.check').is_str(new_opt) and new_opt ~= '' then
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
---@param verbose? boolean Enable verbose printing if `true`
function M.optset(O, verbose)
  validate({
    O = { O, { 'table' } },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  if verbose == nil then
    verbose = false
  end
  if not vim.api.nvim_get_option_value('modifiable', { buf = curr_buf() }) then
    return
  end

  local msg, verb_msg = '', ''
  local opts = M.long_opts_convert(O, verbose)
  for k, v in pairs(opts) do
    if type(vim.o[k]) == type(v) then
      M.options[k] = v
      vim.o[k] = M.options[k]
      verb_msg = ('%s- %s: %s\n'):format(verb_msg, k, vim.inspect(v))
    end
  end
  if msg ~= '' then
    vim.notify(msg, ERROR)
  elseif verbose then
    vim.notify(verb_msg, INFO)
  end
end

---Set up `guicursor` so that cursor blinks.
--- ---
function M.set_cursor_blink()
  if require('user_api.check').in_console() then
    return
  end
  M.optset({
    guicursor = 'n-v-c:block'
      .. ',i-ci-ve:ver25'
      .. ',r-cr:hor20'
      .. ',o:hor50'
      .. ',a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'
      .. ',sm:block-blinkwait175-blinkoff150-blinkon175',
  })
end

function M.print_set_opts()
  local T = vim.deepcopy(M.options)
  table.sort(T)
  vim.notify(vim.inspect(T), INFO)
end

---@param O string[]|string
---@param verbose? boolean
function M.toggle(O, verbose)
  validate({
    O = { O, { 'string', 'table' } },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  if verbose == nil then
    verbose = false
  end

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
    if in_list(M.toggleable, opt) then
      local value = vim.o[opt]
      if Value.is_bool(value) then
        value = not value
      else
        value = value == 'yes' and 'no' or 'yes'
      end
      M.optset({ [opt] = value }, verbose)
    end
  end
end

function M.setup_cmds()
  local Commands = require('user_api.commands')
  local desc = require('user_api.commands').desc
  Commands.add_command('OptsToggle', function(ctx)
    local cmds = {}
    for _, v in ipairs(ctx.fargs) do
      if not (in_list(M.toggleable, v) or ctx.bang) then
        vim.notify(('(OptsToggle): Cannot toggle option `%s`, aborting'):format(v), ERROR)
        return
      end
      if in_list(M.toggleable, v) and not in_list(cmds, v) then
        table.insert(cmds, v)
      end
    end
    M.toggle(cmds, ctx.bang)
  end, desc('Toggle Vim Options', true, '+', toggle_completer))
  Commands.add_command('OptsToggleable', function(ctx)
    local toggleable = M.gen_toggleable(ctx.bang)
    local msg = ''
    for i, v in ipairs(toggleable) do
      msg = ('%s%s%s'):format(msg, i == 1 and '' or '\n', v)
    end
    vim.notify(msg)
  end, desc('Print all toggleable options', true))
end

function M.setup_maps()
  local desc = require('user_api.maps').desc
  require('user_api.config.keymaps').set({
    n = {
      ['<leader>UO'] = { group = '+Options' },
      ['<leader>UOl'] = { M.print_set_opts, desc('Print options set by `user.opts`') },
      ['<leader>UOT'] = { ':OptsToggle ', desc('Prompt To Toggle Opts', { silent = false }) },
    },
  })
end

---@param override? User.Opts.Spec A table with custom options
---@param verbose? boolean Flag to make the function return a string with invalid values, if any
---@param cursor_blink? boolean Whether to enable cursor blinking
function M.setup(override, verbose, cursor_blink)
  validate({
    override = { override, { 'table', 'nil' }, true },
    verbose = { verbose, { 'boolean', 'nil' }, true },
    cursor_blink = { cursor_blink, { 'boolean', 'nil' }, true },
  })
  if verbose == nil then
    verbose = false
  end
  if cursor_blink == nil then
    cursor_blink = false
  end

  if vim.tbl_isempty(M.options) then
    M.options = M.long_opts_convert(M.get_defaults(), verbose)
  end

  local parsed_opts = M.long_opts_convert(override or {}, verbose)
  M.options = vim.tbl_deep_extend('keep', parsed_opts, M.options) ---@type vim.bo|vim.wo
  M.optset(M.options, verbose)

  if cursor_blink then
    M.set_cursor_blink()
  end
end

local Opts = setmetatable(M, { ---@type User.Opts
  __index = function(self, k)
    if require('user_api.check').module('user_api.opts.' .. k) then
      return require('user_api.opts.' .. k)
    end
    return rawget(self, k) or nil
  end,
})

return Opts
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
