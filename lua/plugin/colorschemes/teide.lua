---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class TeideSubMod
local Teide = {}

function Teide.valid()
  return require('user_api.check.exists').module('teide')
end

function Teide.setup()
  vim.cmd.colorscheme('teide')
end

return Teide
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
