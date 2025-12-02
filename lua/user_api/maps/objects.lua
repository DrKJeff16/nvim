---@class User.Maps.Opts: vim.keymap.set.Opts
local O = {}

---@param self User.Maps.Opts
---@param T User.Maps.Opts
function O:add(T)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table' }, false, 'User.Maps.Opts|table')
    else
        vim.validate({ T = { T, { 'table' } } })
    end
    if not require('user_api.check.value').type_not_empty('table', T) then
        return
    end

    for k, v in pairs(T) do
        if not vim.list_contains({ 'add', 'new' }, k) then
            self[k] = v
        end
    end
end

---@param T? User.Maps.Opts
---@return User.Maps.Opts
function O.new(T)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table', 'nil' }, true, 'User.Maps.Opts|table')
    else
        vim.validate({ T = { T, { 'table', 'nil' }, true } })
    end
    return setmetatable(T or {}, { __index = O })
end

return O
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
