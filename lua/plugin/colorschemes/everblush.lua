---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class EverblushSubMod
local Everblush = {}

function Everblush.valid()
    return require('user_api.check.exists').module('everblush')
end

function Everblush.setup()
    vim.cmd.colorscheme('everblush')
end

return Everblush
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
