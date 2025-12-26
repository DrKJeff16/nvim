---@class SpaceDuckSubMod
local SpaceDuck = {}

function SpaceDuck.valid()
  return vim.g.installed_spaceduck == 1
end

function SpaceDuck.setup()
  vim.cmd.colorscheme('spaceduck')
end

return SpaceDuck
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
