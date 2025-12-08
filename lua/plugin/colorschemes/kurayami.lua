---A submodule class for the `kurayami.nvim` colorscheme.
--- ---
---@class KurayamiSubMod
local Kurayami = {}

function Kurayami.valid()
    return require('user_api.check.exists').module('kurayami')
end

function Kurayami.setup()
    vim.cmd.colorscheme('kurayami')
end

return Kurayami
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
