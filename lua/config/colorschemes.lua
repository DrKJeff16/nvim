---@param color? string
return function(color)
  require('user_api').check.validate({ color = { color, { 'string', 'nil' }, true } })
  color = color or 'tokyonight'

  local colors = vim.fn.getcompletion('', 'color', true) --[[@as string[]\]]
  if not vim.list_contains(colors, color) then
    color = vim.list_contains(colors, 'tokyonight') and 'tokyonight' or 'default'
  end

  pcall(vim.cmd.colorscheme, color)
end
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
