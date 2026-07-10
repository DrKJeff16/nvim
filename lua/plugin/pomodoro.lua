---@module 'lazy'
return { ---@type LazySpec
  'yal212/pomodoro.nvim',
  dev = true,
  version = false,
  cmd = 'Pomodoro',
  config = function()
    require('pomodoro').setup({
      durations = { work = 25, short_break = 5, long_break = 15 },
      cycles_per_long_break = 4,
      daily_goal = 0,
      auto_start_break = true,
      auto_start_work = false,
      notify_styles = { 'vim_notify', 'float' },
      notify = { float_duration_ms = 4000 },
      sound = { enabled = false },
      statusline = { icon = '', show_when_idle = false, format = '%s %s', refresh_ms = 250 },
      status_window = {
        border = 'none',
        width = 36,
        height = 5,
        anchor = 'NE',
        row = 1,
        col_offset = 2,
        refresh_ms = 250,
        show_progress_bar = true,
        show_today = true,
        title_pos = 'center', ---@type "left"|"center"|"right"
        icons = { work = '▶', short_break = '•', long_break = '★', paused = '❚❚', idle = '○' },
      },
      focus = { enabled = true, blocked_commands = {}, silent_diagnostics = false, dim_inactive = true },
      persistence = { enabled = true },
      hooks = {},
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
