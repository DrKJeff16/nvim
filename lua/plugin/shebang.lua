---@module 'lazy'
return { ---@type LazySpec
  'DrKJeff16/shebang.nvim',
  dev = true,
  config = function()
    require('shebang').setup({
      auto_make_executable = true,
      env = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
