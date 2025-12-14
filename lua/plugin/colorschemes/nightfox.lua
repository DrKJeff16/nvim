--- A colorscheme class for the `nightfox.nvim` colorscheme.
--- ---
---@class NFoxSubMod
local Nightfox = {}

function Nightfox.valid()
    return require('user_api.check.exists').module('nightfox')
end

function Nightfox.setup()
    vim.cmd.colorscheme('nightfox')
    require('nightfox').compile()
end

return Nightfox
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
