---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class TemplateSubMod
local Template = {}

function Template.valid()
  return require('user_api.check.exists').module('template')
end

function Template.setup()
  vim.cmd.colorscheme('template')
end

return Template
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
