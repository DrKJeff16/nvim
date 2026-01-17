---@class User.Config
local Config = {}

Config.keymaps = require('user_api.config.keymaps')
Config.neovide = require('user_api.config.neovide')

local M = setmetatable(Config, { ---@type User.Config
  __index = Config,
  __newindex = function()
    vim.notify('User.Config is Read-Only!', vim.log.levels.ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
