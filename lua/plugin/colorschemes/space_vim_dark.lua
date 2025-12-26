---@class SpaceVimSubMod
local SpaceVimDark = {}

function SpaceVimDark.valid()
  return vim.g.installed_space_vim_dark == 1
end

function SpaceVimDark.setup()
  vim.cmd.colorscheme('space-vim-dark')
end

return SpaceVimDark
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
