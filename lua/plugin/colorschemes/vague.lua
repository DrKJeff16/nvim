---A submodule class for the `vague` colorscheme.
--- ---
---@class VagueSubMod
local Vague = {}

function Vague.valid()
    return require('user_api.check.exists').module('vague')
end

function Vague.setup()
    vim.cmd.colorscheme('vague')
end

return Vague
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
