---@enum (key) Colors
local COLORS = { ---@diagnostic disable-line:unused-local
  ['catppuccin-frappe'] = 1,
  ['catppuccin-latte'] = 1,
  ['catppuccin-macchiato'] = 1,
  ['catppuccin-mocha'] = 1,
  ['dracula-soft'] = 1,
  ['gruvdark-light'] = 1,
  ['kanagawa-dragon'] = 1,
  ['kanagawa-lotus'] = 1,
  ['kanagawa-wave'] = 1,
  ['teide-dark'] = 1,
  ['teide-darker'] = 1,
  ['teide-dimmed'] = 1,
  ['teide-light'] = 1,
  ['tokyonight-day'] = 1,
  ['tokyonight-moon'] = 1,
  ['tokyonight-night'] = 1,
  ['tokyonight-storm'] = 1,
  blue = 1,
  carbonfox = 1,
  catppuccin = 1,
  darkblue = 1,
  dawnfox = 1,
  dayfox = 1,
  default = 1,
  delek = 1,
  desert = 1,
  dracula = 1,
  duskfox = 1,
  elflord = 1,
  embark = 1,
  evening = 1,
  flow = 1,
  gruvbox = 1,
  gruvdark = 1,
  habamax = 1,
  industry = 1,
  kanagawa = 1,
  koehler = 1,
  lunaperche = 1,
  miniautumn = 1,
  minicyan = 1,
  minischeme = 1,
  minispring = 1,
  minisummer = 1,
  miniwinter = 1,
  morning = 1,
  murphy = 1,
  nightfox = 1,
  nordfox = 1,
  onedark = 1,
  pablo = 1,
  peachpuff = 1,
  quiet = 1,
  randomhue = 1,
  retrobox = 1,
  ron = 1,
  shine = 1,
  slate = 1,
  sorbet = 1,
  spaceduck = 1,
  teide = 1,
  terafox = 1,
  tokyodark = 1,
  tokyonight = 1,
  torte = 1,
  unokai = 1,
  vague = 1,
  vim = 1,
  wildcharm = 1,
  zaibatsu = 1,
  zellner = 1,
}

---@param color? string|Colors
return function(color)
  require('user_api.check').validate({ color = { color, { 'string', 'nil' }, true } })
  color = color and color:lower() or 'tokyonight'

  local colors = vim.tbl_keys(COLORS) ---@type string[]
  if not vim.list_contains(colors, color) then
    color = require('user_api.check.exists').module('tokyonight') and 'tokyonight'
      or colors[math.random(1, #colors)]
  end

  vim.cmd.colo(color)
end
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
