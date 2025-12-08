---@class SpaceVimSubMod
local SpaceVimDark = {}

function SpaceVimDark.valid()
    return vim.g.installed_space_vim_dark == 1
end

function SpaceVimDark.setup()
    vim.cmd.colorscheme('space-vim-dark')
end

return SpaceVimDark
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
