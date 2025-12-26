--- A colorscheme class for the `nightfox.nvim` colorscheme.
--- ---
---@class NFoxSubMod
local Nightfox = {}

function Nightfox.valid()
  return require('user_api.check.exists').module('nightfox')
end

function Nightfox.setup()
  vim.cmd.colorscheme('nightfox')
  require('nightfox').compile()
end

return Nightfox
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
