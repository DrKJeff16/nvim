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
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
