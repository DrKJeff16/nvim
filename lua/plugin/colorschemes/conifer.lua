---@alias ConiferSubMod.Variant 'lunar'|'solar'

---A submodule class for the `conifer.nvim` colorscheme.
--- ---
---@class ConiferSubMod
local Conifer = {}

---@class ConiferSubMod.Variants
Conifer.variants = { 'lunar', 'solar' }

function Conifer.valid()
  return require('user_api.check.exists').module('conifer')
end

function Conifer.setup()
  vim.cmd.colorscheme('conifer')
end

return Conifer
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
