---@class GruvboxSubMod
local Gruvbox = {}

function Gruvbox.valid()
  return require('user_api.check.exists').module('gruvbox')
end

function Gruvbox.setup()
  vim.cmd.colorscheme('gruvbox')
end

return Gruvbox
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
