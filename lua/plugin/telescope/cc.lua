---@class TelCC
local CC = {}

local function create_cc()
    local Actions = require('telescope._extensions.conventional_commits.actions')
    local Themes = require('telescope.themes')
    local picker = require('telescope._extensions.conventional_commits.picker')
    local Opts = { action = Actions.prompt, include_body_and_footer = true }
    picker(vim.tbl_extend('keep', Opts, Themes.get_dropdown({})))
end

---@class TelCC.Opts
CC.cc = {
    theme = 'dropdown',
    action = function(_)
        local entry = {
            display = 'feat       A new feature',
            index = 7,
            ordinal = 'feat',
            value = 'feat',
        }
        vim.print(entry)
    end,
    include_body_and_footer = true,
}

function CC.loadkeys()
    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
        n = {
            ['<leader>Gc'] = { group = '+Commit' },
            ['<leader>GcC'] = { create_cc, desc('Create Conventional Commit') },
        },
    })
end

return CC
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
