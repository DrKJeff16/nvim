---@alias AllColorSubMods
---|AriakeSubMod
---|ConiferSubMod
---|CpcSubMod
---|DraculaSubMod
---|EmbarkSubMod
---|GruvDarkSubMod
---|GruvboxSubMod
---|KanagawaSubMod
---|KPSubMod
---|KurayamiSubMod
---|MolokaiSubMod
---|NFoxSubMod
---|ODSubMod
---|SpaceDuckSubMod
---|SpaceNvimSubMod
---|SpaceVimSubMod
---|ThornSubMod
---|TNSubMod
---|TokyoDarkSubMod
---|VagueSubMod
---|VSCodeSubMod

local ERROR = vim.log.levels.ERROR

---@class CscMod
local Colorschemes = {}

---@enum (keys) AllCsc
Colorschemes.OPTIONS = {
    Thorn = 'Thorn',
    Kurayami = 'Kurayami',
    Conifer = 'Conifer',
    Tokyonight = 'Tokyonight',
    Nightfox = 'Nightfox',
    Embark = 'Embark',
    Kanagawa = 'Kanagawa',
    Vague = 'Vague',
    Catppuccin = 'Catppuccin',
    Tokyodark = 'Tokyodark',
    KanagawaPaper = 'KanagawaPaper',
    Spaceduck = 'Spaceduck',
    Onedark = 'Onedark',
    Gruvdark = 'Gruvdark',
    Gruvbox = 'Gruvbox',
    Vscode = 'Vscode',
    Ariake = 'Ariake',
    Dracula = 'Dracula',
    Molokai = 'Molokai',
    SpaceVimDark = 'SpaceVimDark',
    SpaceNvim = 'SpaceNvim',
}

-- stylua: ignore start

Colorschemes.Ariake         = require('plugin.colorschemes.ariake')
Colorschemes.Catppuccin     = require('plugin.colorschemes.catppuccin')
Colorschemes.Conifer        = require('plugin.colorschemes.conifer')
Colorschemes.Dracula        = require('plugin.colorschemes.dracula')
Colorschemes.Embark         = require('plugin.colorschemes.embark')
Colorschemes.Gruvbox        = require('plugin.colorschemes.gruvbox')
Colorschemes.Gruvdark       = require('plugin.colorschemes.gruvdark')
Colorschemes.Kanagawa       = require('plugin.colorschemes.kanagawa')
Colorschemes.KanagawaPaper  = require('plugin.colorschemes.kanagawa_paper')
Colorschemes.Kurayami       = require('plugin.colorschemes.kurayami')
Colorschemes.Molokai        = require('plugin.colorschemes.molokai')
Colorschemes.Nightfox       = require('plugin.colorschemes.nightfox')
Colorschemes.Onedark        = require('plugin.colorschemes.onedark')
Colorschemes.SpaceNvim      = require('plugin.colorschemes.space-nvim')
Colorschemes.SpaceVimDark   = require('plugin.colorschemes.space_vim_dark')
Colorschemes.Spaceduck      = require('plugin.colorschemes.spaceduck')
Colorschemes.Thorn          = require('plugin.colorschemes.thorn')
Colorschemes.Tokyodark      = require('plugin.colorschemes.tokyodark')
Colorschemes.Tokyonight     = require('plugin.colorschemes.tokyonight')
Colorschemes.Vague          = require('plugin.colorschemes.vague')
Colorschemes.Vscode         = require('plugin.colorschemes.vscode')

-- stylua: ignore end

---@type CscMod|fun(color?: string|AllCsc|nil)
local M = setmetatable({}, {
    __index = Colorschemes,
    ---@param self CscMod
    ---@param color? string|AllCsc|nil
    __call = function(self, color)
        if vim.fn.has('nvim-0.11') == 1 then
            vim.validate('color', color, { 'string', 'nil' }, true)
        else
            vim.validate({ color = { color, { 'string', 'nil' }, true } })
        end

        local Keys = { ---@type AllMaps
            ['<leader>u'] = { group = '+UI' },
            ['<leader>uc'] = { group = '+Colorschemes' },
        }
        local valid = {} ---@type string[]
        local csc_group = 'A'
        local i = 1
        for _, name in pairs(self.OPTIONS) do
            local TColor = self[name] ---@type AllColorSubMods
            if TColor and TColor.valid and TColor.valid() then
                table.insert(valid, name)
                Keys['<leader>uc' .. csc_group] = { group = '+Group ' .. csc_group }
                Keys[('<leader>uc%s%s'):format(csc_group, i)] = {
                    TColor.setup,
                    require('user_api.maps').desc(('Set Colorscheme `%s`'):format(name)),
                }
                if i == 9 then
                    i = 1
                    csc_group = require('user_api.util').displace_letter(csc_group, 'next')
                elseif i < 9 then
                    i = i + 1
                end
            end
        end
        if vim.tbl_isempty(valid) then
            vim.notify('No valid colorschemes!', ERROR)
        end

        require('user_api.config').keymaps({ n = Keys })

        if not (color and vim.list_contains(valid, color)) then
            color = valid[1]
        end

        local Color = self[color] ---@type AllColorSubMods
        if Color and Color.valid() then
            Color.setup()
            return
        end

        for _, csc in ipairs(valid) do
            Color = self[csc] ---@type AllColorSubMods
            if Color.valid and vim.is_callable(Color.valid) and Color.valid() then
                Color.setup()
                return
            end
        end
        vim.cmd.colorscheme('default')
    end,
})

return M
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
