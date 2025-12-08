--- A colorscheme class for the `onedark.nvim` colorscheme.
--- ---
---@class ODSubMod
local OneDark = {}

function OneDark.valid()
    return require('user_api.check.exists').module('onedark')
end

function OneDark.setup()
    require('onedark').load()
end

return OneDark
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
