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
      bufhidden = 'wipe',
      default_mappings = false,
      dismiss_on_move = false,
      focus_on_open = true,
      force_close = true,
      preview_window_title = { enable = true, position = 'left' },
      references = { provider = 'snacks' },
      resizing_mappings = false,
      same_file_float_preview = true,
      stack_floating_preview_windows = true,
      vim_ui_input = true,
      zindex = 5,
    })

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
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
