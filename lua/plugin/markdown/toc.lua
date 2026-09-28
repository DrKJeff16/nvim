---@module 'lazy'
return { ---@type LazySpec
  'ChuufMaster/markdown-toc',
  dev = true,
  versian = false,
  ft = { 'markdown' },
  cmd = { 'GenerateTOC', 'DeleteTOC' },
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('markdown-toc').setup({
      ask_for_heading_level = true,
      heading_level_to_match = -1,
      toc_format = '%s- [%s](<%s#%s>)',
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
