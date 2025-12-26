---A submodule class for the `tokyodark.nvim` colorscheme.
--- ---
---@class TokyoDarkSubMod
local TokyoDark = {}

function TokyoDark.valid()
  return require('user_api.check.exists').module('tokyodark')
end

function TokyoDark.setup()
  vim.cmd.colorscheme('tokyodark')
end

return TokyoDark
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
