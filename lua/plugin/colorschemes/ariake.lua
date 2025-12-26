---A submodule class for the `ariake.nvim` colorscheme.
--- ---
---@class AriakeSubMod
local Ariake = {}

function Ariake.valid()
  return require('user_api.check.exists').module('ariake')
end

function Ariake.setup()
  vim.cmd.colorscheme('ariake')
end

return Ariake
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
