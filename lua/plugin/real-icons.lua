---@module 'lazy'
return { ---@type LazySpec
  'Mirsmog/real-icons.nvim',
  version = false,
  event = 'VeryLazy',
  build = ':RealIcons install',
  config = function()
    require('real-icons').setup({
      integrations = {
        fzf_lua = true,
        lualine = true,
        neo_tree = true,
        oil = true,
        snacks_picker = true,
        telescope = true,
        telescope_file_browser = true,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
