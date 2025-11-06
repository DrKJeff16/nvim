---@class UserAPI
---@field FAILED? string[]
---@field paths? string[]
local User = {}

User.util = require('user_api.util')
User.check = require('user_api.check')
User.distro = require('user_api.distro')
User.maps = require('user_api.maps')
User.opts = require('user_api.opts')
User.commands = require('user_api.commands')
User.update = require('user_api.update')
User.highlight = require('user_api.highlight')
User.config = require('user_api.config')

function User.setup()
    User.config.keymaps({ n = { ['<leader>U'] = { group = '+User API' } } })
    User.commands.setup()
    User.update.setup()
    User.opts.setup_maps()
    User.opts.setup_cmds()
    User.util.setup_autocmd()
    User.distro()
    User.config.neovide.setup()
end

return User
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
