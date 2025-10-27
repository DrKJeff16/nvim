---A submodule class for the `ariake.nvim` colorscheme.
--- ---
---@class AriakeSubMod
local Template = {}

function Template.valid()
    return require('user_api.check.exists').module('ariake')
end

function Template.setup()
    vim.cmd.colorscheme('ariake')
end

return Template
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
