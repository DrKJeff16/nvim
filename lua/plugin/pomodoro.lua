---@module 'lazy'
return { ---@type LazySpec
  'yal212/pomodoro.nvim',
  dev = true,
  version = false,
  cmd = 'Pomodoro',
  config = function()
    require('pomodoro').setup({
      auto_start_break = true,
      auto_start_work = false,
      cycles_per_long_break = 4,
      daily_goal = 0,
      durations = { work = 25, short_break = 5, long_break = 15 },
      focus = { enabled = true, blocked_commands = {}, silent_diagnostics = false, dim_inactive = true },
      hooks = {},
      notify = { float_duration_ms = 4000 },
      notify_styles = { 'vim_notify', 'float' },
      persistence = { enabled = true },
      sound = { enabled = false },
      status_window = {
        anchor = 'NE',
        border = 'none',
        col_offset = 2,
        height = 5,
        icons = { work = '▶', short_break = '•', long_break = '★', paused = '❚❚', idle = '○' },
        refresh_ms = 250,
        row = 1,
        show_progress_bar = true,
        show_today = true,
        title_pos = 'center',
        width = 36,
      },
      statusline = { format = '%s %s', icon = '', refresh_ms = 250, show_when_idle = false },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
