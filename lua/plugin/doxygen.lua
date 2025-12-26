---@module 'lazy'

return { ---@type LazySpec
  'vim-scripts/DoxygenToolkit.vim',
  ft = { 'c', 'cpp' },
  version = false,
  init = require('config.util').flag_installed('doxygen_toolkit'),
  enabled = require('user_api.check.exists').executable('doxygen'),
  config = function()
    local g_vars = {
      authorName = 'Guennadi Maximov C',
      blockFooter = ('-'):rep(75),
      blockHeader = ('-'):rep(75),
      briefTag_pre = '@brief  ',
      licenseTag = 'MIT',
      paramTag_pre = '@param ',
      returnTag = '@return ',
    }
    for k, v in pairs(g_vars) do
      vim.g[('DoxygenToolkit_%s'):format(k)] = v
    end
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
