local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR
local validate = require('user_api.check').validate

---Helper function for transparency formatting.
--- ---
---@return string alpha_str
local function alpha()
  return ('%x'):format(math.floor(255 * (vim.g.transparency or 1.0)))
end

---@param ev vim.api.keyset.create_autocmd.callback_args
local function set_ime(ev)
  vim.g.neovide_input_ime = ev.event:match('Enter$') ~= nil
end

---@class Config.Neovide.Opts.G
local g_opts = {
  confirm_quit = vim.o.confirm,
  cursor = {
    animate = { in_insert_mode = true, command_line = false },
    animation_length = 0.05,
    antialiasing = false,
    hack = true,
    short_animation_length = 0.03,
    smooth = { blink = true },
    trail_size = 1.0,
  },
  experimental = { layer_grouping = false },
  floating = {
    blur_amount_x = 3.0,
    blur_amount_y = 3.0,
    corner_radius = 0.5,
    shadow = true,
    z_height = 50,
  },
  fullscreen = false,
  hide_mouse_when_typing = false,
  light = { angle_degrees = 45, radius = 5 },
  no_idle = true,
  padding = { top = 0, bottom = 0, left = 0, right = 0 },
  position = { animation = { length = 0.1 } },
  profiler = false,
  refresh_rate = 60,
  refresh_rate_idle = 30,
  remember = { window_size = true },
  scale_factor = 1.0,
  scroll = { animation = { length = 0.07, far_lines = 0 } },
  show_border = true,
  text = { contrast = 0.5, gamma = 0.0 },
  theme = 'auto',
  underline = { stroke_scale = 1.0 },
}

---@class Config.Neovide.Opts.O
local o_opts = { linespace = 0, guifont = 'FiraCode Nerd Font Mono:h19' }

---@class User.Config.Neovide
local Neovide = {}

Neovide.g_opts = {} ---@type table<string, any>
Neovide.active = false ---@type boolean

---@return Config.Neovide.Opts defaults
function Neovide.get_defaults()
  ---@class Config.Neovide.Opts
  ---@field g Config.Neovide.Opts.G
  ---@field o Config.Neovide.Opts.O
  local defaults = { g = g_opts, o = o_opts }

  return defaults
end

---@return boolean active
function Neovide.check()
  return require('user_api.check.exists').executable('neovide') and vim.g.neovide or false
end

---@param opacity number
---@param transparency number
---@param bg string
---@overload fun()
---@overload fun(opacity: number)
---@overload fun(opacity: number, transparency: number)
function Neovide.set_transparency(opacity, transparency, bg)
  validate({
    opacity = { opacity, { 'number', 'nil' } },
    transparency = { transparency, { 'number', 'nil' } },
    bg = { bg, { 'string', 'nil' } },
  })
  opacity = opacity or 0.85
  transparency = transparency or 1.0

  local num_range = require('user_api.check.value').num_range
  local eq = { high = true, low = true }
  opacity = (opacity and not num_range(opacity, 0.0, 1.0, eq)) and 0.85 or opacity
  bg = bg and bg:len() == 7 and bg or '#0f1117'
  transparency = (transparency and not num_range(transparency, 0.0, 1.0, eq)) and 1.0
    or transparency

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
  validate({
    O = { O, { 'table' } },
    pfx = { pfx, { 'string' } },
  })
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
  require('user_api.config').keymaps.set({
    n = {
      ['<leader>n'] = { group = '+Neovide' },
      ['<leader>nV'] = {
        function()
          vim.notify(('Neovide v%s'):format(vim.g.neovide_version), INFO)
        end,
        desc('Show Neovide Version'),
      },
    },
  })
end

---@param T table
---@param transparent boolean
---@param verbose boolean
---@overload fun()
---@overload fun(T: table)
---@overload fun(T: table, transparent: boolean)
function Neovide.setup(T, transparent, verbose)
  validate({
    T = { T, { 'table', 'nil' }, true },
    transparent = { transparent, { 'boolean', 'nil' }, true },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })

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
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
