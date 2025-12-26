---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class EverblushSubMod
local Everblush = {}

function Everblush.valid()
  return require('user_api.check.exists').module('everblush')
end

function Everblush.setup()
  vim.cmd.colorscheme('everblush')
end

return Everblush
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
