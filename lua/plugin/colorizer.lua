---@module 'lazy'
return { ---@type LazySpec
  'catgoose/nvim-colorizer.lua',
  version = false,
  event = 'BufReadPre',
  config = function()
    require('colorizer').setup({
      buftypes = { '' },
      filetypes = { '*' },
      lazy_load = true,
      options = {
        always_update = false,
        display = {
          mode = 'background',
          priority = { default = 150, lsp = 200 },
          virtualtext = { char = '■', hl_mode = 'foreground', position = 'eol' },
        },
        hooks = {
          should_highlight_line = function(line) ---@param line string
            return line:sub(1, 2) ~= '--'
          end,
        },
        parsers = {
          css = true,
          css_fn = true,
          custom = {},
          hex = { aarrggbb = false, default = true, rgb = true, rgba = true, rrggbb = true, rrggbbaa = true },
          hsl = { enable = true },
          names = {
            camelcase = true,
            custom = false,
            enable = false,
            lowercase = true,
            strip_digits = false,
            uppercase = true,
          },
          oklch = { enable = true },
          rgb = { enable = true },
          sass = { enable = false, parsers = { css = true }, variable_pattern = '^%$([%w_-]+)' },
          tailwind = { enable = true, lsp = true, update_names = true },
          xterm = { enable = false },
        },
      },
      user_commands = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
