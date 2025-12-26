---A submodule class for the `vague` colorscheme.
--- ---
---@class VagueSubMod
local Vague = {}

function Vague.valid()
  return require('user_api.check.exists').module('vague')
end

function Vague.setup()
  vim.cmd.colorscheme('vague')
end

return Vague
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
