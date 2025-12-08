--- A colorscheme table for the `vscode.nvim` colorscheme.
--- ---
---@class VSCodeSubMod
local VSCode = {}

function VSCode.valid()
    return require('user_api.check.exists').module('vscode')
end

function VSCode.setup()
    require('vscode').load()
end

return VSCode
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
