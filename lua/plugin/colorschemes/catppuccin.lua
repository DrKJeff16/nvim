---@alias CpcSubMod.Variant 'frappe'|'latte'|'macchiato'|'mocha'

--- A submodule class for the `catppuccin.nvim` colorscheme.
--- ---
---@class CpcSubMod
local Catppuccin = {}

---@class CpcSubMod.Variants
Catppuccin.variants = { 'frappe', 'macchiato', 'mocha', 'latte' }

---@return boolean
function Catppuccin.valid()
  return require('user_api.check.exists').module('catppuccin')
end

function Catppuccin.setup()
  vim.cmd.colorscheme('catppuccin')
end

return Catppuccin
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
