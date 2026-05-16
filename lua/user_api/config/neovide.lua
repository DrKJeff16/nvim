local INFO = vim.log.levels.INFO
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
---@field g_opts table<string, any>
---@field active boolean
local M = {}

M.g_opts = {}
M.active = false

---@return Config.Neovide.Opts defaults
function M.get_defaults()
  ---@class Config.Neovide.Opts
  ---@field g Config.Neovide.Opts.G
  ---@field o Config.Neovide.Opts.O
  local defaults = { g = g_opts, o = o_opts }

  return defaults
end

---@return boolean active
function M.check()
  return require('user_api.check.exists').executable('neovide') and vim.g.neovide or false
end

---@param opacity? number
---@param transparency? number
---@param bg? string
function M.set_transparency(opacity, transparency, bg)
  validate({
    opacity = { opacity, { 'number', 'nil' }, true },
    transparency = { transparency, { 'number', 'nil' }, true },
    bg = { bg, { 'string', 'nil' }, true },
  })
  opacity = opacity or 0.85
  transparency = transparency or 1.0

  local num_range = require('user_api.check.value').num_range
  local eq = { high = true, low = true }
  opacity = num_range(opacity, 0.0, 1.0, eq) and opacity or 0.85
  bg = bg and bg:len() == 7 and bg or '#0f1117'
  transparency = num_range(transparency, 0.0, 1.0, eq) and transparency or 1.0

  if bg:sub(1, 1) == '#' then
    bg = ((bg:len() ~= 7 and bg:len() ~= 9) and '#0f1117' or bg) .. alpha()
  end

  M.g_opts.neovide_opacity = opacity
  M.g_opts.transparency = transparency
  M.g_opts.neovide_background_color = bg
end

---@param O any[]
---@param pfx string
function M.parse_g_opts(O, pfx)
  validate({
    O = { O, { 'table' } },
    pfx = { pfx, { 'string' } },
  })
  pfx = pfx:sub(1, 8) == 'neovide_' and pfx or 'neovide_'

  for k, v in ipairs(O) do
    local key = pfx .. k
    if require('user_api.check.value').is_tbl(v) then
      M.parse_g_opts(v, key .. '_')
    else
      M.g_opts[key] = v
    end
  end
end

function M.setup_maps()
  if not M.check() then
    return
  end

  local desc = require('user_api.maps').desc
  require('user_api.config.keymaps').set({
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

---@param T? table
---@param transparent? boolean
---@param verbose? boolean
function M.setup(T, transparent, verbose)
  validate({
    T = { T, { 'table', 'nil' }, true },
    transparent = { transparent, { 'boolean', 'nil' }, true },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })

  if not M.check() then
    return
  end
  T = T or {}
  if transparent == nil then
    transparent = false
  end
  if verbose == nil then
    verbose = false
  end

  local Defaults = M.get_defaults()
  for o, v in pairs(Defaults.o) do
    vim.o[o] = v
  end

  M.g_opts = {}
  T = vim.tbl_deep_extend('keep', T, Defaults.g)
  M.parse_g_opts(T, 'neovide_')
  if transparent then
    M.set_transparency()
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
  for k, v in pairs(M.g_opts) do
    vim.g[k] = v
  end

  if verbose then
    vim.notify(vim.inspect(M.g_opts), INFO)
  end
  M.setup_maps()
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
