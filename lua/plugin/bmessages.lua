---@module 'lazy'
return { ---@type LazySpec
  'ariel-frischer/bmessages.nvim',
  event = 'CmdlineEnter',
  version = false,
  config = function()
    require('bmessages').setup({
      autoscroll = true,
      buffer_name = 'bmessages',
      disable_create_user_commands = false,
      keep_focus = true,
      split_type = 'vsplit',
      timer_interval = 1000,
      use_timer = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
