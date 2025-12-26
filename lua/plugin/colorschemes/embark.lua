---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class EmbarkSubMod
local Embark = {}

function Embark.valid()
  return vim.g.installed_embark == 1
end

function Embark.setup()
  vim.o.termguicolors = true
  if require('user_api.check.exists').module('embark') then
    require('embark').setup()
  end
  vim.cmd.colorscheme('embark')
end

return Embark
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
