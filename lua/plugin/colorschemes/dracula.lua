---A colorscheme table for the `dracula.nvim` colorscheme
--- ---
---@class DraculaSubMod
local Dracula = {}

function Dracula.valid()
    return require('user_api.check.exists').module('dracula')
end

function Dracula.setup()
    vim.cmd.colorscheme('dracula')
end

return Dracula
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
