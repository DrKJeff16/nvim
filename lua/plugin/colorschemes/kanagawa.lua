--- A `CscSubMod` variant but for the `kanagawa` colorscheme.
--- ---
---@class KanagawaSubMod
local Kanagawa = {}

function Kanagawa.valid()
    return require('user_api.check.exists').module('kanagawa')
end

function Kanagawa.setup()
    vim.cmd.colorscheme('kanagawa')
end

return Kanagawa
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
