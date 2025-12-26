---@module 'lazy'

return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  config = function()
    require('ts_context_commentstring').setup({ enable_autocmd = false })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
