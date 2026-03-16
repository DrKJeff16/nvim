---@module 'lazy'
return { ---@type LazySpec
  'epwalsh/pomo.nvim',
  version = false,
  dependencies = { 'rcarriga/nvim-notify' },
  config = function()
    require('pomo').setup({
      update_interval = 1000,
      notifiers = {
        { name = 'Default', opts = { sticky = true, title_icon = '⏳', text_icon = '⏱️' } },
        { name = 'System' },
      },
      timers = { Break = { { name = 'System' } } },
      sessions = {
        pomodoro = {
          { name = 'Work', duration = '30m' },
          { name = 'Short Break', duration = '15m' },
          { name = 'Work', duration = '30m' },
          { name = 'Short Break', duration = '15m' },
          { name = 'Work', duration = '30m' },
          { name = 'Long Break', duration = '45m' },
        },
      },
    })

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('pomodoro', { clear = true }),
      callback = function()
        vim.schedule(function()
          vim.cmd.TimerSession('pomodoro')

          for _, timer in ipairs(require('pomo').get_all_timers()) do
            timer:hide()
          end
        end)
      end,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
