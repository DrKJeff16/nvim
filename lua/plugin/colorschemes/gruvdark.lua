---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class GruvDarkSubMod
local GruvDark = {}

function GruvDark.valid()
    return require('user_api.check.exists').module('gruvdark')
end

function GruvDark.setup()
    vim.cmd.colorscheme('gruvdark')
end

return GruvDark
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
