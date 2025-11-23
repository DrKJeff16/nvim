---@class UserAPI
local User = {
    opts = require('user_api.opts'),
    distro = require('user_api.distro'),
    config = require('user_api.config'),
}

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

local M = setmetatable(User, {
    __index = User,
    __newindex = function(_, _, _)
        vim.notify('User table is read-only!', vim.log.levels.ERROR)
    end,
})

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
