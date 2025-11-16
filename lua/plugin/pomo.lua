---@module 'lazy'

return { ---@type LazySpec
    'epwalsh/pomo.nvim',
    cmd = { 'TimerStart', 'TimerRepeat', 'TimerSession' },
    version = false,
    opts = {
        update_interval = 1000,
        notifiers = {
            { name = 'Default', opts = { sticky = true, title_icon = '󱎫', text_icon = '󰄉' } },
            { name = 'System' },
        },
        timers = { Break = { { name = 'System' } } },
        sessions = {
            pomodoro = {
                { name = 'Work', duration = '25m' },
                { name = 'Short Break', duration = '5m' },
                { name = 'Work', duration = '25m' },
                { name = 'Short Break', duration = '5m' },
                { name = 'Work', duration = '25m' },
                { name = 'Long Break', duration = '15m' },
            },
        },
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
