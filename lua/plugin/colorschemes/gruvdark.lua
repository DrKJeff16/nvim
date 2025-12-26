---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class GruvDarkSubMod
local GruvDark = {}

function GruvDark.valid()
  return require('user_api.check.exists').module('gruvdark')
end

function GruvDark.setup()
  vim.cmd.colorscheme('gruvdark')
end

return GruvDark
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
