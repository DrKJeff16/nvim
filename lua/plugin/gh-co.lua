---@module 'lazy'

return { ---@type LazySpec
    'comatory/gh-co.nvim',
    version = false,
    config = function()
        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = { ['<leader>Gg'] = { '<CMD>GhCoWho<CR>', desc('Print GitHub Codeowners') } },
        })
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
