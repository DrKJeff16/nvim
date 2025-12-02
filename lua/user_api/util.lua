local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO
local curr_buf = vim.api.nvim_get_current_buf
local curr_win = vim.api.nvim_get_current_win
local in_list = vim.list_contains

---@class User.Util
local Util = {
    notify = require('user_api.util.notify'),
    au = require('user_api.util.autocmd'),
    string = require('user_api.util.string'),
}

function Util.has_words_before()
    local win = curr_win()
    local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(win))
    return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s')
            == nil
end

---@param s string[]|string
---@param bufnr? integer
---@return table<string, any> res
function Util.get_opts_tbl(s, bufnr)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('s', s, { 'string', 'table' }, false, 'string[]|string')
        vim.validate('bufnr', bufnr, { 'number', 'nil' }, true)
    else
        vim.validate({
            s = { s, { 'string', 'table' } },
            bufnr = { bufnr, { 'number', 'nil' }, true },
        })
    end
    bufnr = bufnr or curr_buf()

    local Value = require('user_api.check.value')
    local res = {} ---@type table<string, any>
    if Value.type_not_empty('string', s) then ---@cast s string
        res[s] = vim.api.nvim_get_option_value(s, { buf = bufnr })
    end
    if Value.type_not_empty('table', s) then ---@cast s string[]
        for _, opt in ipairs(s) do
            res[opt] = Util.get_opts_tbl(opt, bufnr)
        end
    end
    return res
end

---@param T table<string, any>
---@param steps? integer
---@param direction? 'l'|'r'
---@return table<string, any> res
function Util.mv_tbl_values(T, steps, direction)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table' }, false, 'table<string, any>')
        vim.validate('steps', steps, { 'number', 'nil' }, true, 'integer')
        vim.validate('direction', direction, { 'string', 'nil' }, true, "'l'|'r'")
    else
        vim.validate({
            T = { T, { 'table' } },
            steps = { steps, { 'number', 'nil' }, true },
            direction = { direction, { 'string', 'nil' }, true },
        })
    end
    steps = steps > 0 and steps or 1
    direction = (direction ~= nil and in_list({ 'l', 'r' }, direction)) and direction or 'r'

    local direction_funcs = { ---@class DirectionFuns
        r = function(t) ---@param t table<string, any>
            local keys = vim.tbl_keys(t) ---@type string[]
            table.sort(keys)

            local res = {} ---@type table<string, any>
            local len = #keys
            for i, v in ipairs(keys) do
                res[v] = t[keys[i == 1 and len or (i - 1)]]
            end
            return res
        end,
        l = function(t) ---@param t table<string, any>
            local keys = vim.tbl_keys(t) ---@type string[]
            table.sort(keys)

            local res = {} ---@type table<string, any>
            local len = #keys
            for i, v in ipairs(keys) do
                res[v] = t[keys[i == len and 1 or (i + 1)]]
            end
            return res
        end,
    }

    local res, func = T, direction_funcs[direction]
    while steps > 0 do
        res = func(res)
        steps = steps - 1
    end
    return res
end

---@param x boolean
---@param y boolean
---@return boolean
function Util.xor(x, y)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('x', x, { 'boolean' }, false)
        vim.validate('y', y, { 'boolean' }, false)
    else
        vim.validate({
            x = { x, { 'boolean' } },
            y = { y, { 'boolean' } },
        })
    end

    return (x and not y) or (not x and y)
end

---@param T table<string, any>
---@param fields string|integer|(string|integer)[]
---@return table<string, any> T
function Util.strip_fields(T, fields)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table' }, false, 'table<string, any>')
        vim.validate('fields', fields, { 'string', 'number', 'table' }, false)
    else
        vim.validate({
            T = { T, { 'table' } },
            fields = { fields, { 'string', 'number', 'table' } },
        })
    end

    local Value = require('user_api.check.value')
    if Value.is_str(fields) then ---@cast fields string
        if not (Value.type_not_empty('string', fields) and Value.fields(fields, T)) then
            return T
        end
        for k, _ in pairs(T) do
            if k == fields then
                T[k] = nil
            end
        end
        return T
    end
    for k, _ in pairs(T) do
        ---@cast fields (string|integer)[]
        if in_list(fields, k) then
            T[k] = nil
        end
    end
    return T
end

---@param T table<string, any>
---@param values any[]
---@param max_instances? integer
---@return table<string, any> res
function Util.strip_values(T, values, max_instances)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table' }, false, 'table<string, any>')
        vim.validate('values', values, { 'table' }, false, 'any[]')
        vim.validate('max_instances', max_instances, { 'table', 'nil' }, true)
    else
        vim.validate({
            T = { T, { 'table' } },
            values = { values, { 'table' } },
            max_instances = { max_instances, { 'table', 'nil' }, true },
        })
    end

    local Value = require('user_api.check.value')
    if not (Value.type_not_empty('table', T) or Value.type_not_empty('table', values)) then
        error('(user_api.util.strip_values): Empty tables as args!', ERROR)
    end

    max_instances = max_instances or 0
    local res, count = {}, 0 ---@type table<string, any>, integer
    for k, v in pairs(T) do
        -- Both arguments can't be true simultaneously
        if Util.xor((max_instances == 0), (max_instances ~= 0 and max_instances > count)) then
            if not in_list(values, v) and Value.is_int(k) then
                table.insert(res, v)
            elseif not in_list(values, v) then
                res[k] = v
            else
                count = count + 1
            end
        elseif Value.is_int(k) then
            table.insert(res, v)
        else
            res[k] = v
        end
    end
    return res
end

---@param s? string
---@param bufnr? integer
---@return function
function Util.ft_set(s, bufnr)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('s', s, { 'string', 'nil' }, true)
        vim.validate('bufnr', bufnr, { 'number', 'nil' }, true)
    else
        vim.validate({
            s = { s, { 'string', 'nil' }, true },
            bufnr = { bufnr, { 'number', 'nil' }, true },
        })
    end

    return function()
        vim.api.nvim_set_option_value('filetype', s or '', { buf = bufnr or curr_buf() })
    end
end

---@param bufnr? integer
function Util.bt_get(bufnr)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('bufnr', bufnr, { 'number', 'nil' }, true)
    else
        vim.validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })
    end

    return vim.bo[bufnr or curr_buf()].buftype
end

---@param bufnr? integer
---@return string
function Util.ft_get(bufnr)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('bufnr', bufnr, { 'number', 'nil' }, true)
    else
        vim.validate({ bufnr = { bufnr, { 'number', 'nil' }, true } })
    end
    return vim.bo[bufnr or curr_buf()].filetype
end

---@param T any[]
---@param V any
---@return table T
---@return any val
function Util.pop_values(T, V)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table' }, false)
    else
        vim.validate({ T = { T, { 'table' } } })
    end

    local idx = 0
    for i, v in ipairs(T) do
        if v == V then
            idx = i
            break
        end
    end
    if idx < 1 or idx > #T then
        return T
    end
    return T, table.remove(T, idx)
end

function Util.setup_autocmd()
    local group = vim.api.nvim_create_augroup('User.AU', { clear = true })
    local autocmds = { ---@type AuRepeatEvents[]
        {
            events = { 'BufCreate', 'BufAdd', 'BufNew', 'BufNewFile', 'BufRead' },
            opts_tbl = {
                {
                    group = group,
                    pattern = '*.org',
                    callback = function(ev)
                        Util.ft_set('org', ev.buf)()
                    end,
                },
                {
                    group = group,
                    pattern = '.spacemacs',
                    callback = function(ev)
                        Util.ft_set('lisp', ev.buf)()
                    end,
                },
                {
                    group = group,
                    pattern = '*.el',
                    callback = function(ev)
                        Util.ft_set('lisp', ev.buf)()
                    end,
                },
                {
                    group = group,
                    pattern = '.clangd',
                    callback = function(ev)
                        Util.ft_set('yaml', ev.buf)()
                    end,
                },
                {
                    group = group,
                    pattern = '*.norg',
                    callback = function(ev)
                        Util.ft_set('norg', ev.buf)()
                    end,
                },
                {
                    group = group,
                    pattern = { '*.c', '*.h' },
                    callback = function(ev)
                        local buf_opts = { buf = ev.buf } ---@type vim.api.keyset.option
                        local opt_dict = {
                            tabstop = 2,
                            shiftwidth = 2,
                            softtabstop = 2,
                            expandtab = true,
                            autoindent = true,
                            filetype = 'c',
                        }
                        for opt, val in pairs(opt_dict) do
                            vim.api.nvim_set_option_value(opt, val, buf_opts)
                        end
                    end,
                },
                {
                    group = group,
                    pattern = {
                        '*.C',
                        '*.H',
                        '*.c++',
                        '*.cc',
                        '*.cpp',
                        '*.cxx',
                        '*.h++',
                        '*.hh',
                        '*.hpp',
                        '*.html',
                        '*.hxx',
                        '*.md',
                        '*.mdx',
                        '*.yaml',
                        '*.yml',
                    },
                    callback = function(ev)
                        local buf_opts = { buf = ev.buf } ---@type vim.api.keyset.option
                        local opt_dict = {
                            tabstop = 2,
                            shiftwidth = 2,
                            softtabstop = 2,
                            expandtab = true,
                            autoindent = true,
                        }
                        for opt, val in pairs(opt_dict) do
                            vim.api.nvim_set_option_value(opt, val, buf_opts)
                        end
                    end,
                },
            },
        },
        {
            events = { 'FileType' },
            opts_tbl = {
                {
                    pattern = 'checkhealth',
                    group = group,
                    callback = function()
                        local O = { win = curr_win() } ---@type vim.api.keyset.option
                        vim.api.nvim_set_option_value('wrap', true, O)
                        vim.api.nvim_set_option_value('number', false, O)
                        vim.api.nvim_set_option_value('signcolumn', 'no', O)
                    end,
                },
                {
                    pattern = 'nvim-undotree',
                    group = group,
                    callback = function(ev)
                        vim.keymap.set(
                            'n',
                            'q',
                            vim.cmd.bdelete,
                            { buffer = ev.buf, noremap = true }
                        )
                    end,
                },
                {
                    pattern = 'startuptime',
                    group = group,
                    callback = function(ev)
                        vim.keymap.set(
                            'n',
                            'q',
                            vim.cmd.bdelete,
                            { buffer = ev.buf, noremap = true }
                        )
                    end,
                },
            },
        },
        {
            events = { 'BufEnter', 'WinEnter', 'BufWinEnter' },
            opts_tbl = {
                {
                    group = group,
                    callback = function(ev)
                        local executable = require('user_api.check.exists').executable
                        local desc = require('user_api.maps').desc

                        local bt = Util.bt_get(ev.buf)
                        local ft = Util.ft_get(ev.buf)
                        local win_opts = { win = curr_win() } ---@type vim.api.keyset.option
                        local buf_opts = { buf = ev.buf } ---@type vim.api.keyset.option
                        if ft == 'lazy' then
                            vim.api.nvim_set_option_value('signcolumn', 'no', win_opts)
                            vim.api.nvim_set_option_value('number', false, win_opts)
                            return
                        end
                        if bt == 'help' or ft == 'help' then
                            vim.api.nvim_set_option_value('signcolumn', 'no', win_opts)
                            vim.api.nvim_set_option_value('number', false, win_opts)
                            vim.api.nvim_set_option_value('wrap', true, win_opts)
                            vim.api.nvim_set_option_value('colorcolumn', '', win_opts)
                            vim.keymap.set('n', 'q', vim.cmd.bdelete, { buffer = ev.buf })

                            local fn = vim.schedule_wrap(function()
                                vim.cmd.wincmd('=')
                                vim.cmd.noh()
                            end)
                            fn()
                            return
                        end
                        if ft == 'ministarter' then
                            vim.keymap.set('n', 'q', vim.cmd.quit, { buffer = ev.buf })
                            return
                        end
                        if not vim.api.nvim_get_option_value('modifiable', buf_opts) then
                            return
                        end
                        if ft == 'lua' and executable('stylua') then
                            require('user_api.config').keymaps({
                                n = {
                                    ['<leader><C-l>'] = {
                                        function()
                                            ---@diagnostic disable-next-line:param-type-mismatch
                                            local ok = pcall(vim.cmd, 'silent! !stylua %')
                                            if not ok then
                                                return
                                            end
                                            vim.notify('Formatted successfully!', INFO, {
                                                title = 'StyLua',
                                                animate = true,
                                                timeout = 200,
                                                hide_from_history = true,
                                            })
                                        end,
                                        desc('Format With `stylua`'),
                                    },
                                },
                            }, ev.buf)
                        end
                        if ft == 'python' and executable('isort') then
                            require('user_api.config').keymaps({
                                n = {
                                    ['<leader><C-l>'] = {
                                        function()
                                            ---@diagnostic disable-next-line:param-type-mismatch
                                            local ok = pcall(vim.cmd, 'silent! !isort %')
                                            if not ok then
                                                return
                                            end
                                            vim.notify('Formatted successfully!', INFO, {
                                                title = 'isort',
                                                animate = true,
                                                timeout = 200,
                                                hide_from_history = true,
                                            })
                                        end,
                                        desc('Format With `isort`'),
                                    },
                                },
                            }, ev.buf)
                        end
                    end,
                },
            },
        },
    }

    Util.au.created = vim.tbl_deep_extend('keep', Util.au.created or {}, autocmds) ---@type AuRepeatEvents[]

    for _, t in ipairs(Util.au.created) do
        Util.au.au_repeated_events(t)
    end
end

---@param c string
---@param direction? 'next'|'prev'
---@return string
function Util.displace_letter(c, direction)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('c', c, { 'string' }, false)
        vim.validate('direction', direction, { 'string', 'nil' }, true)
    else
        vim.validate({
            c = { c, { 'string' } },
            direction = { direction, { 'string', 'nil' }, true },
        })
    end
    local Value = require('user_api.check.value')
    local mv = Util.mv_tbl_values
    local A = vim.deepcopy(Util.string.alphabet)

    if c == '' then
        return 'a'
    end

    direction = in_list({ 'next', 'prev' }, direction) and direction or 'next'
    local LOWER, UPPER = A.lower_map, A.upper_map
    if direction == 'prev' then
        if Value.fields(c, LOWER) then
            return mv(LOWER, 1, 'r')[c]
        end
        return mv(UPPER, 1, 'r')[c]
    end
    if Value.fields(c, LOWER) then
        return mv(LOWER, 1, 'l')[c]
    end
    return mv(UPPER, 1, 'l')[c]
end

---@param data string|table
---@return string|table res
function Util.discard_dups(data)
    local Value = require('user_api.check.value')
    if not (Value.type_not_empty('string', data) or Value.type_not_empty('table', data)) then
        vim.notify('Input is not valid!', ERROR, {
            animate = true,
            hide_from_history = false,
            timeout = 2750,
            title = '(user_api.util.discard_dups)',
        })
        return data
    end

    ---@cast data string
    if Value.is_str(data) then
        local res = data:sub(1, 1)
        local i = 2
        while i < data:len() do
            local c = data:sub(i, i)
            if not res:match(c) then
                res = res .. c
            end
            i = i + 1
        end
        return res
    end

    local res = {} ---@type table

    ---@cast data table
    for k, v in pairs(data) do
        if not vim.tbl_contains(res, v) then
            res[k] = v
        end
    end
    return res
end

---@param T any[]
---@return any[]
function Util.reverse_tbl(T)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table' }, false)
    else
        vim.validate({ T = { T, { 'table' } } })
    end
    if vim.tbl_isempty(T) then
        error('(user_api.util.reverse_tbl): Empty or non-existant table', ERROR)
    end

    local len = #T
    for i = 1, math.floor(len / 2), 1 do
        T[i], T[len - i + 1] = T[len - i + 1], T[i]
    end
    return T
end

local M = setmetatable(Util, { ---@type User.Util
    __index = Util,
    __newindex = function()
        vim.notify('User.Util is Read-Only!', ERROR)
    end,
})

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
