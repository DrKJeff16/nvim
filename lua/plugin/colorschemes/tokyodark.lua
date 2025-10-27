---A submodule class for the `tokyodark.nvim` colorscheme.
--- ---
---@class TokyoDarkSubMod
local TokyoDark = {}

function TokyoDark.valid()
    return require('user_api.check.exists').module('tokyodark')
end

function TokyoDark.setup()
    vim.cmd.colorscheme('tokyodark')
end

return TokyoDark
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
