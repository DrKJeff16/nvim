---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class ThornSubMod
local Thorn = {}

function Thorn.valid()
    return require('user_api.check.exists').module('thorn')
end

function Thorn.setup()
    vim.cmd.colorscheme('thorn')
end

return Thorn
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
