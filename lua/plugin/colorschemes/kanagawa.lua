--- A `CscSubMod` variant but for the `kanagawa` colorscheme.
--- ---
---@class KanagawaSubMod
local Kanagawa = {}

function Kanagawa.valid()
  return require('user_api.check.exists').module('kanagawa')
end

function Kanagawa.setup()
  vim.cmd.colorscheme('kanagawa')
end

return Kanagawa
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
