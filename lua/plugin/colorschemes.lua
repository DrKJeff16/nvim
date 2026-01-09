---@param color? string
return function(color)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('color', color, { 'string', 'nil' }, true)
  else
    vim.validate({ color = { color, { 'string', 'nil' }, true } })
  end
  color = color or 'tokyonight'
  color = color:lower()

  if not vim.list_contains(vim.fn.getcompletion('', 'color'), color) then
    color = 'tokyonight'
  end

  vim.cmd.colorscheme(color)
end
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
