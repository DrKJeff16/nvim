local in_list = vim.list_contains

---@class User.Util.String
local String = {}

---@class User.Util.String.Alphabet
String.alphabet = {
    ---@class User.Util.String.Alphabet.UpperList
    upper_list = {
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
    },
    ---@class User.Util.String.Alphabet.LowerList
    lower_list = {
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
        'h',
        'i',
        'j',
        'k',
        'l',
        'm',
        'n',
        'o',
        'p',
        'q',
        'r',
        's',
        't',
        'u',
        'v',
        'w',
        'x',
        'y',
        'z',
    },
    ---@class User.Util.String.Alphabet.UpperMap
    upper_map = {
        A = 'A',
        B = 'B',
        C = 'C',
        D = 'D',
        E = 'E',
        F = 'F',
        G = 'G',
        H = 'H',
        I = 'I',
        J = 'J',
        K = 'K',
        L = 'L',
        M = 'M',
        N = 'N',
        O = 'O',
        P = 'P',
        Q = 'Q',
        R = 'R',
        S = 'S',
        T = 'T',
        U = 'U',
        V = 'V',
        W = 'W',
        X = 'X',
        Y = 'Y',
        Z = 'Z',
    },
    ---@class User.Util.String.Alphabet.LowerMap
    lower_map = {
        a = 'a',
        b = 'b',
        c = 'c',
        d = 'd',
        e = 'e',
        f = 'f',
        g = 'g',
        h = 'h',
        i = 'i',
        j = 'j',
        k = 'k',
        l = 'l',
        m = 'm',
        n = 'n',
        o = 'o',
        p = 'p',
        q = 'q',
        r = 'r',
        s = 's',
        t = 't',
        u = 'u',
        v = 'v',
        w = 'w',
        x = 'x',
        y = 'y',
        z = 'z',
    },
    ---@class User.Util.String.Alphabet.Vowels
    vowels = {
        ---@class User.Util.String.Alphabet.Vowels.UpperList
        upper_list = { 'A', 'E', 'I', 'O', 'U' },
        ---@class User.Util.String.Alphabet.Vowels.LowerList
        lower_list = { 'a', 'e', 'i', 'o', 'u' },
        ---@class User.Util.String.Alphabet.Vowels.UpperMap
        upper_map = { A = 'A', E = 'E', I = 'I', O = 'O', U = 'U' },
        ---@class User.Util.String.Alphabet.Vowels.LowerMap
        lower_map = { a = 'a', e = 'e', i = 'i', o = 'o', u = 'u' },
    },
}

---@class User.Util.String.Digits
String.digits = {
    ---@class User.Util.String.Digits.All
    all = {
        ['0'] = '0',
        ['1'] = '1',
        ['2'] = '2',
        ['3'] = '3',
        ['4'] = '4',
        ['5'] = '5',
        ['6'] = '6',
        ['7'] = '7',
        ['8'] = '8',
        ['9'] = '9',
    },
    ---@class User.Util.String.Digits.OddList
    odd_list = { '1', '3', '5', '7', '9' },
    ---@class User.Util.String.Digits.EvenList
    even_list = { '0', '2', '4', '6', '8' },
    ---@class User.Util.String.Digits.EvenMap
    even_map = { ['0'] = '0', ['2'] = '2', ['4'] = '4', ['6'] = '6', ['8'] = '8' },
    ---@class User.Util.String.Digits.OddMap
    odd_map = { ['1'] = '1', ['3'] = '3', ['5'] = '5', ['7'] = '7', ['9'] = '9' },
}

---@param str string
---@param use_dot? boolean
---@param triggers? string[]
---@return string new_str
function String.capitalize(str, use_dot, triggers)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('str', str, { 'string' }, false)
        vim.validate('use_dot', use_dot, { 'boolean', 'nil' }, true)
        vim.validate('triggers', triggers, { 'table', 'nil' }, true, 'string[]')
    else
        vim.validate({
            str = { str, { 'string' } },
            use_dot = { use_dot, { 'boolean', 'nil' }, true },
            triggers = { triggers, { 'table', 'nil' }, true },
        })
    end
    if str == '' then
        return str
    end

    use_dot = use_dot ~= nil and use_dot or false
    triggers = vim.tbl_deep_extend('force', triggers or {}, { ' ', '' })

    local strlen = str:len()
    local prev_char, new_str, i = '', '', 1
    local dot = true
    while i <= strlen do
        local char = str:sub(i, i)
        if char == char:lower() and in_list(triggers, prev_char) then
            char = dot and char:upper() or char:lower()
            if dot then
                dot = false
            end
        else
            char = char:lower()
        end

        if use_dot and not dot then
            dot = char == '.'
        elseif not use_dot then
            dot = true
        end

        new_str = ('%s%s'):format(new_str, char)
        prev_char = char
        i = i + 1
    end
    return new_str
end

---@param str string
---@param target string
---@param new string
function String.replace(str, target, new)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('str', str, { 'string' }, false)
        vim.validate('target', target, { 'string' }, false)
        vim.validate('new', new, { 'string' }, false)
    else
        vim.validate({
            str = { str, { 'string' } },
            target = { target, { 'string' } },
            new = { new, { 'string' } },
        })
    end
    if in_list({ str:len(), target:len(), new:len() }, 0) or new == target then
        return str
    end

    local new_str, len = '', str:len()
    for i = 1, len, 1 do
        local c = str:sub(i, i)
        c = c == target and new or c
        new_str = ('%s%s'):format(new_str, c)
    end
    return new_str
end

local M = setmetatable(String, { ---@type User.Util.String
    __index = String,
    __newindex = function()
        vim.notify('User.Util.String is Read-Only!', vim.log.levels.ERROR)
    end,
})

return M
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
