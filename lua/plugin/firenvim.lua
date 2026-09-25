---@module 'lazy'
return { ---@type LazySpec
  'glacambre/firenvim',
  lazy = false,
  version = false,
  build = ':call firenvim#install(0)',
  cond = not require('user_api').check.is_root(),
  config = function()
    vim.g.firenvim_config = {
      localSettings = {
        [ [[.*]] ] = {
          cmdline = 'firenvim',
          priority = 0,
          selector = 'textarea:not([readonly]):not([class="handsontableInput"]), div[role="textbox"]',
          takeover = 'always',
        },
      },
      globalSettings = {
        alt = 'all',
        cmdlineTimeout = 10000,
        ignoreKeys = {
          all = { '<C-->' },
          normal = { '<C-1>', '<C-2>' },
        },
      },
    }

    vim.api.nvim_create_autocmd({ 'UIEnter' }, {
      callback = function()
        local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
        if client ~= nil and client.name == 'Firenvim' then
          vim.o.laststatus = 0
        end
      end,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
