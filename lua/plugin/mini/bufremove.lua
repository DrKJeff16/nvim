---@module 'lazy'

---@param force? boolean
---@return function
local function gen_bdel(force)
  force = force ~= nil and force or false
  return function()
    require('mini.bufremove').delete(vim.api.nvim_get_current_buf(), force)
  end
end

return { ---@type LazySpec
  'nvim-mini/mini.bufremove',
  version = false,
  config = function()
    require('mini.bufremove').setup({ silent = true })

    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps.set({
      n = {
        ['<leader>bd'] = { gen_bdel(), desc('Close Buffer (Mini)') },
        ['<leader>bD'] = { gen_bdel(true), desc('Close Buffer Forcefully (Mini)') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
