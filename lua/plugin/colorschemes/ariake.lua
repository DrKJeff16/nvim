---A submodule class for the `ariake.nvim` colorscheme.
--- ---
---@class AriakeSubMod
local Ariake = {}

function Ariake.valid()
    return require('user_api.check.exists').module('ariake')
end

function Ariake.setup()
    vim.cmd.colorscheme('ariake')
end

return Ariake
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
