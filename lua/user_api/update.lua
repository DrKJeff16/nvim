local WARN = vim.log.levels.WARN
local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO

---@class User.Update
local M = {}

---@param verbose? boolean
function M.update(verbose)
  require('user_api.check').validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
  if verbose == nil then
    verbose = false
  end

  local spinner = require('user_api.util.spinner').new('user', { kind = 'cursor' })
  if spinner then
    spinner:start()
  end

  local command = { 'git', 'pull', '--rebase' }
  vim.system(command, { text = true, cwd = vim.fn.stdpath('config') }, function(obj)
    if spinner then
      spinner:stop()
    end

    if verbose and obj.stdout and obj.stdout ~= '' then
      vim.notify(obj.stdout, INFO, {
        animate = true,
        hide_from_history = false,
        timeout = 2250,
        title = 'User API - Update',
      })
    end

    if obj.code ~= 0 then
      vim.notify('Failed to update Jnvim, try to do it manually', ERROR, {
        animate = true,
        hide_from_history = false,
        timeout = 5000,
        title = 'User API - Update',
      })
      if verbose and obj.stderr and obj.stderr ~= '' then
        vim.notify(obj.stderr, WARN, {
          animate = true,
          hide_from_history = false,
          timeout = 2250,
          title = 'User API - Update',
        })
      end
      return
    end

    if obj.stdout and obj.stdout:match('Already up to date') then
      vim.notify('Jnvim is up to date!', INFO, {
        animate = true,
        hide_from_history = true,
        timeout = 1750,
        title = 'User API - Update',
      })
      return
    end
    vim.notify('You need to restart Nvim!', WARN, {
      animate = true,
      hide_from_history = false,
      timeout = 5000,
      title = 'User API - Update',
    })
  end)
end

function M.setup()
  local desc = require('user_api.maps').desc
  require('user_api.config.keymaps').set({
    n = {
      ['<leader>U'] = { group = '+User API' },
      ['<leader>Uu'] = { M.update, desc('Update User Config') },
      ['<leader>UU'] = {
        function()
          M.update(true)
        end,
        desc('Update User Config (Verbose)'),
      },
    },
  })

  vim.api.nvim_create_user_command('UserUpdate', function(ctx)
    M.update(ctx.bang)
  end, { bang = true, desc = 'Update Jnvim' })
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
