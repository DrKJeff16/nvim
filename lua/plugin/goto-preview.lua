---@module 'lazy'
return { ---@type LazySpec
  'rmagatti/goto-preview',
  event = 'BufEnter',
  version = false,
  dependencies = { 'rmagatti/logger.nvim' },
  config = function()
    local GTP = require('goto-preview')
    GTP.setup({
      border = { '↖', '─', '┐', '│', '┘', '─', '└', '│' },
      default_mappings = false,
      resizing_mappings = false,
      references = { provider = 'snacks' },
      focus_on_open = true,
      dismiss_on_move = false,
      force_close = true,
      bufhidden = 'wipe',
      stack_floating_preview_windows = true,
      same_file_float_preview = true,
      preview_window_title = { enable = true, position = 'left' },
      zindex = 5,
      vim_ui_input = true,
    })

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps.set({
      n = {
        ['<leader>g'] = { group = '+Go To' },
        ['<leader>gp'] = { group = '+Preview' },
        ['<leader>gpD'] = { GTP.goto_preview_declaration, desc('Declaration') },
        ['<leader>gpP'] = { GTP.close_all_win, desc('Go To Preview Close All') },
        ['<leader>gpd'] = { GTP.goto_preview_definition, desc('Definition') },
        ['<leader>gpi'] = { GTP.goto_preview_implementation, desc('Implementation') },
        ['<leader>gpr'] = { GTP.goto_preview_references, desc('References') },
        ['<leader>gpt'] = { GTP.goto_preview_type_definition, desc('Type Definition') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
