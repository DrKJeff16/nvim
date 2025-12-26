--- A colorscheme class for the `onedark.nvim` colorscheme.
--- ---
---@class ODSubMod
local OneDark = {}

function OneDark.valid()
  return require('user_api.check.exists').module('onedark')
end

function OneDark.setup()
  require('onedark').load()
end

return OneDark
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
