local MODSTR = 'config.util'
local ERROR = vim.log.levels.ERROR

---@class Config.Util
local CfgUtil = {}

---@param force? boolean
function CfgUtil.set_tgc(force)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('force', force, { 'boolean', 'nil' }, true)
    else
        vim.validate({ force = { force, { 'boolean', 'nil' }, true } })
    end
    force = force ~= nil and force or false

    vim.o.termguicolors = not force
            and (require('user_api.check.exists').vim_exists('+termguicolors') and not require(
                'user_api.check'
            ).in_console())
        or true
end

---@param name string
---@param callback? function
---@return function
function CfgUtil.flag_installed(name, callback)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('name', name, 'string', false)
        vim.validate('callback', callback, { 'function', 'nil' }, true)
    else
        vim.validate({
            name = { name, 'string' },
            callback = { callback, { 'function', 'nil' }, true },
        })
    end
    if name == '' then
        error(('(%s.flag_installed): Unable to set `vim.g` var'):format(MODSTR), ERROR)
    end

    local flag = (name:sub(1, 10) == 'installed_') and name or ('installed_' .. name)
    return function()
        vim.g[flag] = 1
        if callback and vim.is_callable(callback) then
            callback()
        end
    end
end

---Set the global condition for a later submodule call.
--- ---
---@param fields string|table<string, any>
---@param force_tgc? boolean
---@return function
function CfgUtil.colorscheme_init(fields, force_tgc)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('fields', fields, { 'string', 'table' }, false, 'string|table<string, any>')
        vim.validate('force_tgc', force_tgc, 'boolean', true, 'boolean?')
    else
        vim.validate({
            fields = { fields, { 'string', 'table' } },
            force_tgc = { force_tgc, { 'boolean', 'nil' }, true },
        })
    end
    force_tgc = force_tgc ~= nil and force_tgc or false

    return function()
        CfgUtil.set_tgc(force_tgc)
        if require('user_api.check.value').is_str(fields) then
            CfgUtil.flag_installed(fields)()
            return
        end
        for field, val in pairs(fields) do
            vim.g[field] = val
        end
    end
end

---A `config` function to call your plugin from a `lazy` spec.
--- ---
---@param mod_str string
---@return function
function CfgUtil.require(mod_str)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('mod_str', mod_str, 'string', false)
    else
        vim.validate({ mod_str = { mod_str, 'string' } })
    end

    return function()
        if require('user_api.check.exists').module(mod_str) then
            require(mod_str)
        end
    end
end

---Returns the string for the `build` field for `Telescope-fzf` depending on certain conditions.
---
---For UNIX systems, it'll be something akin to:
---
---```sh
---make
---```
---
---If `nproc` is found in `PATH` or a valid executable then the string could look like:
---
---```sh
---make -j"$(nproc)"
---```
---
---If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`.
---If unsuccessful, **it'll return `false`**.
--- ---
---@return string|false cmd
function CfgUtil.tel_fzf_build()
    local executable = require('user_api.check.exists').executable
    if not executable({ 'make', 'mingw32-make' }) then
        return false
    end
    return executable({ 'make', 'nproc' }) and 'make -j"$(nproc)"'
        or (executable('make') and 'make' or 'mingw32-make')
end

function CfgUtil.luarocks_check()
    return require('user_api.check.exists').executable('luarocks')
        and require('user_api.check.exists').env_vars({ 'LUA_PATH', 'LUA_CPATH' })
end

---@param cmd? 'ed'|'tabnew'|'split'|'vsplit'
---@return function
function CfgUtil.key_variant(cmd)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('cmd', cmd, { 'string', 'nil' }, true, "'ed'|'tabnew'|'split'|'vsplit'")
    else
        vim.validate({ cmd = { cmd, { 'string', 'nil' }, true } })
    end
    cmd = cmd or 'ed'
    cmd = vim.list_contains({ 'ed', 'tabnew', 'split', 'vsplit' }, cmd) and cmd or 'ed'

    return function()
        vim.cmd[cmd](vim.fn.stdpath('config') .. '/lua/config/lazy.lua')
    end
end

function CfgUtil.has_tgc()
    if
        require('user_api.check').in_console()
        or not require('user_api.check.exists').vim_exists('+termguicolors')
    then
        return false
    end
    return vim.o.termguicolors
end

return CfgUtil
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
