---@module 'lazy'
return { ---@type LazySpec
  'StefanBartl/migrate.nvim',
  version = false,
  dependencies = { 'StefanBartl/lib.nvim', 'nvim-telescope/telescope.nvim' },
  cmd = { 'MigrateOpt', 'MigrateNotify', 'MigrateHl', 'MigrateLsp' },
  config = function()
    require('migrate').setup()
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
