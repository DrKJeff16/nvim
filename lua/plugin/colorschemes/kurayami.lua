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
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
