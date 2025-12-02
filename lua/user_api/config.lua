---@class User.Config
local Config = {
    keymaps = require('user_api.config.keymaps'),
    neovide = require('user_api.config.neovide'),
}

local M = setmetatable(Config, { ---@type User.Config
    __index = Config,
    __newindex = function()
        vim.notify('User.Config is Read-Only!', vim.log.levels.ERROR)
    end,
})

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
