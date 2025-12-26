local MODSTR = 'user_api.update'
local WARN = vim.log.levels.WARN
local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO
local uv = vim.uv or vim.loop

---@class User.Update
local Update = {
  ---@param verbose? boolean
  update = function(verbose)
    if vim.fn.has('nvim-0.11') == 1 then
      vim.validate('verbose', verbose, { 'boolean', 'nil' }, true)
    else
      vim.validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
    end
    verbose = verbose ~= nil and verbose or false

    local og_cwd = uv.cwd() or vim.fn.getcwd()

    vim.api.nvim_set_current_dir(vim.fn.stdpath('config'))
    local cmd = vim.system({ 'git', 'pull', '--rebase' }, { text = true }):wait(10000)

    vim.api.nvim_set_current_dir(og_cwd)
    if verbose and cmd.stdout and cmd.stdout ~= '' then
      vim.notify(cmd.stdout, INFO, {
        animate = true,
        hide_from_history = false,
        timeout = 2250,
        title = 'User API - Update',
      })
    end
    if cmd.code ~= 0 then
      vim.notify(('Failed to update Jnvim, try to do it manually'):format(MODSTR), ERROR, {
        animate = true,
        hide_from_history = false,
        timeout = 5000,
        title = 'User API - Update',
      })
      if verbose and cmd.stderr and cmd.stderr ~= '' then
        vim.notify(cmd.stderr, WARN, {
          animate = true,
          hide_from_history = false,
          timeout = 2250,
          title = 'User API - Update',
        })
      end
      return
    end

    if cmd.stdout and cmd.stdout:match('Already up to date') then
      vim.notify(('(%s.update): Jnvim is up to date!'):format(MODSTR), INFO, {
        animate = true,
        hide_from_history = true,
        timeout = 1750,
        title = 'User API - Update',
      })
      return
    end
    vim.notify(('(%s.update): You need to restart Nvim!'):format(MODSTR), WARN, {
      animate = true,
      hide_from_history = false,
      timeout = 5000,
      title = 'User API - Update',
    })
  end,
}

function Update.setup()
  local desc = require('user_api.maps').desc
  require('user_api.config').keymaps({
    n = {
      ['<leader>U'] = { group = '+User API' },
      ['<leader>Uu'] = { Update.update, desc('Update User Config') },
      ['<leader>UU'] = {
        function()
          Update.update(true)
        end,
        desc('Update User Config (Verbose)'),
      },
    },
  })

  vim.api.nvim_create_user_command('UserUpdate', function(ctx)
    Update.update(ctx.bang)
  end, { bang = true, desc = 'Update Jnvim' })
end

local M = setmetatable(Update, { ---@type User.Update
  __index = Update,
  __newindex = function()
    vim.notify('User.Update is Read-Only!', ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
