---@class GruvboxSubMod
local Gruvbox = {}

function Gruvbox.valid()
    return require('user_api.check.exists').module('gruvbox')
end

function Gruvbox.setup()
    vim.cmd.colorscheme('gruvbox')
end

return Gruvbox
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
