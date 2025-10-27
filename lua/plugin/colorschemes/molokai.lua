---@class MolokaiSubMod
local Molokai = {}

function Molokai.valid()
    return vim.g.installed_molokai == 1
end

function Molokai.setup()
    vim.cmd.colorscheme('molokai')
end

return Molokai
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
