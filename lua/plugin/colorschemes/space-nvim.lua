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
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
