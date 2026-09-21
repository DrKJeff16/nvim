---@module 'lazy'
return { ---@type LazySpec
  'Mirsmog/real-icons.nvim',
  dev = true,
  version = false,
  build = ':RealIcons install',
  cond = vim.fn.has('nvim-0.12') == 1,
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
