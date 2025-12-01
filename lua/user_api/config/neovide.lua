local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR

---Helper function for transparency formatting.
--- ---
---@return string
local function alpha()
    return ('%x'):format(math.floor(255 * (vim.g.transparency or 1.0)))
end

---@param ev vim.api.keyset.create_autocmd.callback_args
local function set_ime(ev)
    vim.g.neovide_input_ime = ev.event:match('Enter$') ~= nil
end

---@class Config.Neovide.Opts.G
local g_opts = {
    theme = 'auto',
    refresh_rate = 60,
    refresh_rate_idle = 30,
    no_idle = true,
    confirm_quit = vim.o.confirm,
    fullscreen = false,
    profiler = false,
    cursor = {
        hack = false,
        animation_length = 0.05,
        short_animation_length = 0.03,
        trail_size = 1.0,
        antialiasing = false,
        smooth = { blink = true },
        animate = { in_insert_mode = false, command_line = false },
    },
    underline = { stroke_scale = 1.0 },
    experimental = { layer_grouping = false },
    text = { contrast = 0.5, gamma = 0.0 },
    scale_factor = 1.0,
    show_border = true,
    hide_mouse_when_typing = false,
    position = { animation = { length = 0.1 } },
    scroll = { animation = { length = 0.07, far_lines = 0 } },
    remember = { window_size = true },
    padding = { top = 0, bottom = 0, left = 0, right = 0 },
    floating = {
        blur_amount_x = 2.0,
        blur_amount_y = 2.0,
        shadow = true,
        z_height = 50,
        corner_radius = 0.5,
    },
    light = { angle_degrees = 45, radius = 5 },
}

---@class Config.Neovide.Opts.O
local o_opts = { linespace = 0, guifont = 'FiraCode Nerd Font Mono:h19' }

---@class Config.Neovide.Opts
---@field g Config.Neovide.Opts.G
---@field o Config.Neovide.Opts.O

---@class User.Config.Neovide
local Neovide = {}

---@type table<string, any>
Neovide.g_opts = {}

Neovide.active = false

---@return Config.Neovide.Opts
function Neovide.get_defaults()
    return { g = g_opts, o = o_opts }
end

---@return boolean active
function Neovide.check()
    return require('user_api.check.exists').executable('neovide') and vim.g.neovide
end

---@param opacity? number
---@param transparency? number
---@param bg? string
function Neovide.set_transparency(opacity, transparency, bg)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('opacity', opacity, 'number', true)
        vim.validate('transparency', transparency, 'number', true)
        vim.validate('bg', bg, 'string', true)
    else
        vim.validate({
            opacity = { opacity, { 'number', 'nil' } },
            transparency = { transparency, { 'number', 'nil' } },
            bg = { bg, { 'string', 'nil' } },
        })
    end

    local num_range = require('user_api.check.value').num_range
    local eq = { high = true, low = true }
    if opacity and not num_range(opacity, 0.0, 1.0, eq) then
        opacity = 0.85
    end
    if transparency and not num_range(transparency, 0.0, 1.0, eq) then
        transparency = 1.0
    end

    if not bg or bg:len() ~= 7 then
        bg = '#0f1117'
    end

    if bg:sub(1, 1) == '#' then
        bg = ((bg:len() ~= 7 and bg:len() ~= 9) and '#0f1117' or bg) .. alpha()
    end

    Neovide.g_opts.neovide_opacity = opacity
    Neovide.g_opts.transparency = transparency
    Neovide.g_opts.neovide_background_color = bg
end

---@param O any[]
---@param pfx string
function Neovide.parse_g_opts(O, pfx)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('O', O, { 'table' }, false, 'any[]')
        vim.validate('pfx', pfx, { 'string' }, false)
    else
        vim.validate({
            O = { O, { 'table' } },
            pfx = { pfx, { 'string' } },
        })
    end
    pfx = pfx:sub(1, 8) == 'neovide_' and pfx or 'neovide_'

    for k, v in ipairs(O) do
        local key = pfx .. k
        if require('user_api.check.value').is_tbl(v) then
            Neovide.parse_g_opts(v, key .. '_')
        else
            Neovide.g_opts[key] = v
        end
    end
end

function Neovide.setup_maps()
    if not Neovide.check() then
        return
    end

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
        n = {
            ['<leader><CR>'] = { group = '+Neovide' },
            ['<leader><CR>V'] = {
                function()
                    vim.notify(('Neovide v%s'):format(vim.g.neovide_version), INFO, {
                        title = 'Neovide',
                        animate = true,
                        timeout = 1500,
                        hide_from_history = false,
                    })
                end,
                desc('Show Neovide Version'),
            },
        },
    })
end

---@param T? table
---@param transparent? boolean
---@param verbose? boolean
function Neovide.setup(T, transparent, verbose)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('T', T, { 'table', 'nil' }, true)
        vim.validate('transparent', transparent, { 'boolean', 'nil' }, true)
        vim.validate('verbose', verbose, { 'boolean', 'nil' }, true)
    else
        vim.validate({
            T = { T, { 'table', 'nil' }, true },
            transparent = { transparent, { 'boolean', 'nil' }, true },
            verbose = { verbose, { 'boolean', 'nil' }, true },
        })
    end

    if not Neovide.check() then
        return
    end
    T = T or {}
    transparent = transparent ~= nil and transparent or false
    verbose = verbose ~= nil and verbose or false

    local Defaults = Neovide.get_defaults()
    for o, v in pairs(Defaults.o) do
        vim.o[o] = v
    end

    Neovide.g_opts = {}
    T = vim.tbl_deep_extend('keep', T, Defaults.g)
    Neovide.parse_g_opts(T, 'neovide_')
    if transparent then
        Neovide.set_transparency()
    end

    local ime_input = vim.api.nvim_create_augroup('ime_input', { clear = true })
    vim.api.nvim_create_autocmd({ 'InsertEnter', 'InsertLeave' }, {
        group = ime_input,
        pattern = '*',
        callback = set_ime,
    })
    vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'CmdlineLeave' }, {
        group = ime_input,
        pattern = '[/\\?]',
        callback = set_ime,
    })
    for k, v in pairs(Neovide.g_opts) do
        vim.g[k] = v
    end

    if verbose then
        vim.notify(vim.inspect(Neovide.g_opts), INFO)
    end
    Neovide.setup_maps()
end

local M = setmetatable(Neovide, { ---@type User.Config.Neovide
    __index = Neovide,
    __newindex = function()
        vim.notify('User.Config.Neovide is Read-Only!', ERROR)
    end,
})

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
