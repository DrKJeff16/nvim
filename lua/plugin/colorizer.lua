---@module 'lazy'
return { ---@type LazySpec
  'catgoose/nvim-colorizer.lua',
  version = false,
  event = 'BufReadPre',
  config = function()
    require('colorizer').setup({
      filetypes = { '*' },
      buftypes = { '' },
      user_commands = true,
      lazy_load = true,
      options = {
        parsers = {
          css = true,
          css_fn = true,
          names = {
            enable = false,
            lowercase = true,
            camelcase = true,
            uppercase = true,
            strip_digits = false,
            custom = false,
          },
          hex = {
            default = true,
            rgb = true,
            rgba = true,
            rrggbb = true,
            rrggbbaa = true,
            aarrggbb = false,
          },
          rgb = { enable = true },
          hsl = { enable = true },
          oklch = { enable = true },
          tailwind = { enable = true, lsp = true, update_names = true },
          sass = { enable = false, parsers = { css = true }, variable_pattern = '^%$([%w_-]+)' },
          xterm = { enable = false },
          custom = {},
        },
        display = {
          mode = 'background', ---@type 'background'|'foreground'|'virtualtext'
          virtualtext = {
            char = '■',
            position = 'eol', ---@type 'eol'|'before'|'after'
            hl_mode = 'foreground',
          },
          priority = { default = 150, lsp = 200 },
        },
        hooks = {
          should_highlight_line = function(line) ---@param line string
            return line:sub(1, 2) ~= '--'
          end,
        },
        always_update = false,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
