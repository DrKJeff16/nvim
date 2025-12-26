---A submodule class for the `kanagawa-paper` colorscheme.
--- ---
---@class KPSubKPod
local KP = {}

function KP.valid()
  return require('user_api.check.exists').module('kanagawa-paper')
end

function KP.setup()
  vim.cmd.colorscheme('kanagawa-paper')
end

return KP
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
