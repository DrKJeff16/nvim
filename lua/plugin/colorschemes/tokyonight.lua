---@alias TNSubMod.Variant 'night'|'moon'|'day'|'storm'

--- A colorscheme class for the `tokyonight.nvim` colorscheme.
--- ---
---@class TNSubMod
local TokyoNight = {}

---@class TNSubMod.Variants
TokyoNight.variants = { 'storm', 'night', 'moon', 'day' }

function TokyoNight.valid()
    return require('user_api.check.exists').module('tokyonight')
end

function TokyoNight.setup()
    vim.cmd.colorscheme('tokyonight')
end

return TokyoNight
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
