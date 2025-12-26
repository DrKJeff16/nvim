---@class MolokaiSubMod
local Molokai = {}

function Molokai.valid()
  return vim.g.installed_molokai == 1
end

function Molokai.setup()
  vim.cmd.colorscheme('molokai')
end

return Molokai
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
