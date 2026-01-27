local exists = require('user_api.check.exists').module
if not (exists('telescope') and exists('telescope-tabs')) then
  return nil
end

---@class TelescopeTabs
local TelescopeTabs = {}

function TelescopeTabs.create()
  require('telescope').load_extension('telescope-tabs')
  require('telescope-tabs').setup({
    entry_formatter = function(tab_id, _, _, file_paths, is_current)
      local entry_string = table.concat(
        vim.tbl_map(function(v)
          return vim.fn.fnamemodify(v, ':.')
        end, file_paths),
        ', '
      )
      return ('%d: %s%s'):format(tab_id, entry_string, is_current and ' <' or '')
    end,
    entry_ordinal = function(_, _, file_names, _, _)
      return table.concat(file_names, ' ')
    end,
    show_preview = true,
    close_tab_shortcut_i = '<C-d>', -- if you're in insert mode
    close_tab_shortcut_n = 'D', -- if you're in normal mode
  })
end

function TelescopeTabs.loadkeys()
  local desc = require('user_api.maps').desc
  require('user_api.config').keymaps.set({
    n = {
      ['<leader><C-T>et'] = { require('telescope-tabs').list_tabs, desc('Tabs') },
      ['<leader>tt'] = { require('telescope-tabs').list_tabs, desc('Telescope Tabs') },
    },
  })
end

return TelescopeTabs
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
