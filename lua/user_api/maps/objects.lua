local in_list = vim.list_contains

---@class User.Maps.Opts: vim.keymap.set.Opts
local O = {}

---@param T User.Maps.Opts
function O:add(T)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table' }, false)
    else
        vim.validate({ T = { T, { 'table' } } })
    end
    if vim.tbl_isempty(T) then
        return
    end

    for k, v in pairs(T) do
        if not in_list({ 'add', 'new' }, k) then
            self[k] = v
        end
    end
end

---@param T? User.Maps.Opts
---@return User.Maps.Opts new_object
function O.new(T)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table', 'nil' }, true, 'User.Maps.Opts|nil')
    else
        vim.validate({ T = { T, { 'table', 'nil' }, true } })
    end

    return setmetatable(T or {}, { __index = O })
end

return O
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
