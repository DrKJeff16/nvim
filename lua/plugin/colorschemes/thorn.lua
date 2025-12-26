---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class ThornSubMod
local Thorn = {}

function Thorn.valid()
  return require('user_api.check.exists').module('thorn')
end

function Thorn.setup()
  vim.cmd.colorscheme('thorn')
end

return Thorn
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
