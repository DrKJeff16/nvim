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
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
