---A submodule class for the `calvera-dark.nvim` colorscheme.
--- ---
---@class CalaveraSubMod
local Calavera = {}

function Calavera.valid()
    return require('user_api.check.exists').module('calvera')
end

function Calavera.setup()
    require('calvera').set()
end

return Calavera
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
