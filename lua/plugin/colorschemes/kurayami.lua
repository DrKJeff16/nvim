local exists = require('user_api.check.exists').module

---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class KurayamiSubMod
local Kurayami = {}

Kurayami.mod_cmd = 'silent! colorscheme kurayami'

---@return boolean
function Kurayami.valid()
    return exists('kurayami')
end

function Kurayami.setup()
    require('kurayami').setup()
    vim.cmd(Kurayami.mod_cmd)
end

return Kurayami
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
