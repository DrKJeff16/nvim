---A submodule class for the `flow.nvim` colorscheme.
--- ---
---@class FlowSubMod
local Flow = {}

function Flow.valid()
    return require('user_api.check.exists').module('flow')
end

function Flow.setup()
    vim.cmd.colorscheme('flow')
end

return Flow
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
