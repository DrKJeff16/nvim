---A submodule class for the `kanagawa-paper` colorscheme.
--- ---
---@class KPSubKPod
local KP = {}

function KP.valid()
    return require('user_api.check.exists').module('kanagawa-paper')
end

function KP.setup()
    vim.cmd.colorscheme('kanagawa-paper')
end

return KP
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
