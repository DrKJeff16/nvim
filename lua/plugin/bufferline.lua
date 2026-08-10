---@module 'lazy'
return { ---@type LazySpec
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  version = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cond = not require('user_api').check.in_console(),
  config = function()
    _G.__cached_neo_tree_selector = nil
    _G.__get_selector = function()
      return _G.__cached_neo_tree_selector
    end
    local BFL = require('bufferline')
    BFL.setup({
      highlights = {
        background = {
          bg = { attribute = 'bg', highlight = 'StatusLine' },
          fg = { attribute = 'fg', highlight = 'Normal' },
        },
        buffer_selected = {
          bg = { attribute = 'bg', highlight = 'Normal' },
          fg = { attribute = 'fg', highlight = 'Normal' },
        },
        buffer_visible = {
          bg = { attribute = 'bg', highlight = 'Normal' },
          fg = { attribute = 'fg', highlight = 'Normal' },
        },
        close_button = {
          bg = { attribute = 'bg', highlight = 'StatusLine' },
          fg = { attribute = 'fg', highlight = 'Normal' },
        },
        close_button_selected = {
          bg = { attribute = 'bg', highlight = 'Normal' },
          fg = { attribute = 'fg', highlight = 'Normal' },
        },
        close_button_visible = {
          bg = { attribute = 'bg', highlight = 'Normal' },
          fg = { attribute = 'fg', highlight = 'Normal' },
        },
        fill = {
          bg = { attribute = 'bg', highlight = 'StatusLineNC' },
          bold = true,
          fg = { attribute = 'fg', highlight = 'Normal' },
          italic = false,
          undercurl = false,
          underline = false,
        },
        separator = {
          bg = { attribute = 'bg', highlight = 'StatusLine' },
          fg = { attribute = 'bg', highlight = 'Normal' },
        },
        separator_selected = {
          bg = { attribute = 'bg', highlight = 'Normal' },
          fg = { attribute = 'fg', highlight = 'Special' },
        },
        separator_visible = {
          bg = { attribute = 'bg', highlight = 'StatusLineNC' },
          fg = { attribute = 'fg', highlight = 'Normal' },
        },
      },
      options = {
        always_show_bufferline = true,
        auto_toggle_bufferline = false,
        buffer_close_icon = '󰅖',
        close_command = 'bdelete! %d',
        close_icon = '',
        color_icons = true,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(_, _, diags, context) ---@param diags table<string, string>
          if not (context and context.buffer:current()) then
            return ''
          end

          local s = ' '
          for e, n in pairs(diags) do
            local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or '')
            s = ('%s%s%s'):format(s, n, sym)
          end
          return s
        end,
        diagnostics_update_in_insert = false,
        diagnostics_update_on_event = false,
        duplicates_across_groups = true,
        enforce_regular_tabs = true,
        get_element_icon = function(element) ---@param element { filetype: string, path: string, extension: string, directory: string }
          return require('mini.icons').get('extension', element.filetype)
        end,
        groups = {
          items = { require('bufferline.groups').builtin.pinned:with({ icon = '' }) },
          options = { toggle_hidden_on_enter = true },
        },
        hover = { enabled = false },
        indicator = { icon = '▎', style = 'none' },
        left_trunc_marker = '',
        max_name_length = 28,
        max_prefix_length = 16,
        mode = 'tabs',
        modified_icon = '●',
        move_wraps_at_ends = true,
        numbers = 'ordinal',
        offsets = {
          { filetype = 'NvimTree', separator = true, text = 'Nvim Tree', text_align = 'center' },
          { filetype = 'lazy', separator = true, text = 'Lazy', text_align = 'center' },
          { filetype = 'notify', separator = true, text = 'Notification', text_align = 'center' },
          {
            filetype = 'neo-tree',
            highlight = { sep = { link = 'WinSeparator' } },
            raw = ' %{%v:lua.__get_selector()%} ',
            separator = '┃',
          },
        },
        persist_buffer_sort = true,
        pick = { alphabet = 'abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890' },
        right_trunc_marker = '',
        separator_style = 'padded_slope',
        show_buffer_close_icons = false,
        show_buffer_icons = true,
        show_duplicate_prefix = true,
        show_tab_indicators = true,
        sort_by = 'tabs',
        style_preset = { BFL.style_preset.no_italic, BFL.style_preset.default },
        tab_size = 16,
        themable = true,
        truncate_names = true,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
