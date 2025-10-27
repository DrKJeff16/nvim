---A submodule class for the `space-nvim` colorscheme.
--- ---
---@class SpaceNvimSubMod
local SpaceNvim = {}

function SpaceNvim.valid()
    return require('user_api.check.exists').module('space-nvim')
end

function SpaceNvim.setup()
    vim.cmd.colorscheme('space-nvim')
end

return SpaceNvim
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
