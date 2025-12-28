---@module 'lazy'
return { ---@type LazySpec
  'ariel-frischer/bmessages.nvim',
  event = 'CmdlineEnter',
  version = false,
  config = function()
    require('bmessages').setup({
      timer_interval = 1000,
      split_type = 'vsplit', ---@type 'split'|'vsplit'
      split_direction = nil, ---@type nil|'topleft'|'bottright'
      split_size_vsplit = nil,
      split_size_split = nil,
      autoscroll = true,
      use_timer = true,
      buffer_name = 'bmessages',
      disable_create_user_commands = false,
      keep_focus = true,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
