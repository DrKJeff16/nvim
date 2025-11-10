---@class UserAPI
local User = {}

User.opts = require('user_api.opts')
User.distro = require('user_api.distro')
User.config = require('user_api.config')

function User.setup()
    User.config.keymaps({ n = { ['<leader>U'] = { group = '+User API' } } })
    require('user_api.commands').setup()
    require('user_api.update').setup()
    User.opts.setup_maps()
    User.opts.setup_cmds()
    require('user_api.util').setup_autocmd()
    User.distro()
    User.config.neovide.setup()
end

return User
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
