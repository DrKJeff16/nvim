---A submodule class for the `lavender` colorscheme.
--- ---
---@class LavenderSubMod
local Lavender = {}

---@return boolean
function Lavender.valid()
  return require('user_api.check.exists').module('lavender')
end

function Lavender.setup()
  vim.cmd.colorscheme('lavender')
end

return Lavender
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
