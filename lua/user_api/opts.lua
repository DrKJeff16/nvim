local MODSTR = 'user_api.opts'
local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO
local in_list = vim.list_contains
local curr_buf = vim.api.nvim_get_current_buf

---@class User.Opts
local Opts = {
    options = {}, ---@type User.Opts.Spec
    ---@return User.Opts.AllOpts all_opts
    get_all_opts = function()
        return require('user_api.opts.all_opts')
    end,
    ---@return User.Opts.Spec defaults
    get_defaults = function()
        return require('user_api.opts.config')
    end,
}

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
    for _, opt in ipairs(long) do
        local value = vim.api.nvim_get_option_value(opt, { scope = 'global' })
        if type(value) == 'boolean' or in_list({ 'no', 'yes' }, value) then
            table.insert(valid, opt)
        end
    end
    for _, opt in ipairs(short) do
        if opt ~= '' then
            local value = vim.api.nvim_get_option_value(opt, { scope = 'global' })
            if type(value) == 'boolean' or in_list({ 'no', 'yes' }, value) then
                table.insert(valid, opt)
            end
        end
    end
    table.sort(valid)
    return valid
end

Opts.toggleable = Opts.gen_toggleable()

---@param T User.Opts.Spec
---@param verbose? boolean
---@return User.Opts.Spec parsed_opts
function Opts.long_opts_convert(T, verbose)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table' }, false)
        vim.validate('verbose', verbose, { 'boolean', 'nil' }, true)
    else
        vim.validate({
            T = { T, { 'table' } },
            verbose = { verbose, { 'boolean', 'nil' }, true },
        })
    end
    verbose = verbose ~= nil and verbose or false

    local Value = require('user_api.check.value')
    local parsed_opts = {} ---@type User.Opts.Spec
    local msg, verb_str = '', ''
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
        -- If neither long nor short (known) option, append to warning message
        if not (in_list(keys, opt) or Value.tbl_values({ opt }, ALL_OPTIONS)) then
            msg = ('%s- Option `%s` not valid!\n'):format(msg, opt)
        elseif in_list(keys, opt) then
            parsed_opts[opt] = val
        else
            local new_opt = Value.tbl_values({ opt }, ALL_OPTIONS, true)
            if Value.is_str(new_opt) and new_opt ~= '' then
                parsed_opts[new_opt] = val
                verb_str = ('%s%s ==> %s\n'):format(verb_str, opt, new_opt)
            else
                msg = ('%s- Option `%s` non valid!\n'):format(msg, new_opt)
            end
        end
    end

    if msg and msg ~= '' then
        vim.notify(msg, ERROR)
    elseif verbose and verb_str and verb_str ~= '' then
        vim.notify(verb_str, INFO)
    end
    return parsed_opts
end

--- Option setter for the aforementioned options dictionary.
--- ---
--- @param O User.Opts.Spec A dictionary with keys acting as `vim.o` fields, and values
--- @param verbose? boolean Enable verbose printing if `true`
function Opts.optset(O, verbose)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('O', O, { 'table' }, false, 'User.Opts.Spec')
        vim.validate('verbose', verbose, { 'boolean', 'nil' }, true)
    else
        vim.validate({
            O = { O, { 'table' } },
            verbose = { verbose, { 'boolean', 'nil' }, true },
        })
    end
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
---@param verbose? boolean
function Opts.toggle(O, verbose)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('O', O, { 'string', 'table' }, false, 'string[]|string')
        vim.validate('verbose', verbose, { 'boolean', 'nil' }, true)
    else
        vim.validate({
            O = { O, { 'string', 'table' } },
            verbose = { verbose, { 'boolean', 'nil' }, true },
        })
    end
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
    require('user_api.commands').add_command('OptsToggle', function(ctx)
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
    end, {
        nargs = '+',
        complete = toggle_completer,
        bang = true,
        desc = 'Toggle toggleable Vim Options',
    })
end

function Opts.setup_maps()
    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
        n = {
            ['<leader>UO'] = { group = '+Options' },
            ['<leader>UOl'] = { Opts.print_set_opts, desc('Print options set by `user.opts`') },
            ['<leader>UOT'] = { ':OptsToggle ', desc('Prompt To Toggle Opts', false) },
        },
    })
end

function Opts.setup()
    Opts.setup_cmds()
    Opts.setup_maps()
end

local M = setmetatable(Opts, { ---@type User.Opts|fun(override?: User.Opts.Spec, verbose?: boolean)
    __index = Opts,
    __newindex = function()
        vim.notify(('(%s): This module is read only!'):format(MODSTR), ERROR)
    end,
    ---@param self User.Opts
    ---@param override? User.Opts.Spec A table with custom options
    ---@param verbose? boolean Flag to make the function return a string with invalid values, if any
    __call = function(self, override, verbose)
        if vim.fn.has('nvim-0.11') == 1 then
            vim.validate('override', override, { 'table', 'nil' }, true, 'User.Opts.Spec')
            vim.validate('verbose', verbose, { 'boolean', 'nil' }, true)
        else
            vim.validate({
                override = { override, { 'table', 'nil' }, true },
                verbose = { verbose, { 'boolean', 'nil' }, true },
            })
        end
        override = override or {}
        verbose = verbose ~= nil and verbose or false

        local defaults = Opts.get_defaults()
        if vim.tbl_isempty(self.options) then
            self.options = Opts.long_opts_convert(defaults, verbose)
        end

        local parsed_opts = Opts.long_opts_convert(override, verbose)
        Opts.options = vim.tbl_deep_extend('keep', parsed_opts, self.options) ---@type vim.bo|vim.wo
        Opts.optset(Opts.options, verbose)
    end,
})

return M
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
