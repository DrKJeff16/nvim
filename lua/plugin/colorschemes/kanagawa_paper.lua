---A submodule class for the `kanagawa-paper` colorscheme.
--- ---
---@class KPSubMod
local M = {}

function M.valid()
    return require('user_api.check.exists').module('kanagawa-paper')
end

function M.setup()
    vim.cmd.colorscheme('kanagawa-paper')
end

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
