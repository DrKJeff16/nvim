---@param color string
---@overload fun()
return function(color)
  require('user_api.check.exists').validate({ color = { color, { 'string', 'nil' }, true } })
  color = color and color:lower() or 'tokyonight'

  local colors = vim.fn.getcompletion('', 'color') ---@type string[]
  if not vim.list_contains(colors, color) then
    color = require('user_api.check.exists').module('tokyonight') and 'tokyonight'
      or colors[math.random(1, #colors)]
  end

  vim.cmd.colo(color)
end
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
