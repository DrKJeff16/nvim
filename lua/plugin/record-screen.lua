---@module 'lazy'
return { ---@type LazySpec
  'wsdjeg/record-screen.nvim',
  keys = {
    { '<F8>', '<CMD>lua require("record-screen").start()' },
    { '<F9>', '<CMD>lua require("record-screen").stop()' },
  },
  version = false,
  dependencies = { 'wsdjeg/job.nvim', 'wsdjeg/notify.nvim' },
  config = function()
    require('record-screen').setup({
      cmd = 'ffmpeg',
      argvs = { '-f', 'gdigrab', '-i', 'desktop', '-f', 'mp4' },
      target_dir = '~/Videos/Recordings',
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
