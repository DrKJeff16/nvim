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
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
