local uv = vim.uv or vim.loop

local function timer_cb()
  local logfile = vim.fs.joinpath(vim.fn.stdpath('state'), 'nvim.log')
  local stat = uv.fs_stat(logfile)
  if not stat or stat.size < 1048576 then -- 1GiB
    return
  end

  local fd = uv.fs_open(logfile, 'w', tonumber('644', 8))
  if not fd then
    return
  end

  uv.fs_ftruncate(fd, 0)
  uv.fs_close(fd)

  vim.notify(('`%s` has been cleared!'):format(logfile), vim.log.levels.INFO)
end

local function make_timer()
  if _G.USER_TIMER and _G.USER_TIMER:is_active() then
    return
  end

  _G.USER_TIMER = uv.new_timer()
  if not _G.USER_TIMER then
    return
  end

  _G.USER_TIMER:start(10000, 900000, vim.schedule_wrap(timer_cb))

  local group = vim.api.nvim_create_augroup('lsp_autoclear', { clear = true })
  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = group,
    callback = function()
      if not (_G.USER_TIMER and _G.USER_TIMER:is_active()) then
        return
      end

      _G.USER_TIMER:stop()
      _G.USER_TIMER = nil
    end,
  })
end

---@class UserAPI
local User = {}

function User.disable_netrw()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

---@param commands? table<string, User.Commands.CmdSpec>
---@param verbose? boolean
function User.setup(commands, verbose)
  require('user_api.check').validate({
    commands = { commands, { 'table', 'nil' }, true },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  verbose = verbose ~= nil and verbose or false

  require('user_api.commands').setup(commands or {})
  require('user_api.update').setup()

  require('user_api.opts').setup()
  require('user_api.distro').setup(verbose)

  require('user_api.config.neovide').setup()
  require('user_api.pickers').setup()

  local desc = require('user_api.maps').desc
  require('user_api.config.keymaps').set({
    n = {
      ['<leader>U'] = { group = '+User API' },
      ['<leader><leader>'] = { require('user_api.pickers').run, desc('Select Picker') },
    },
  })

  make_timer()
end

local M = setmetatable(User, { ---@type UserAPI
  __index = User,
  __newindex = function()
    vim.notify('User API is Read-Only!', vim.log.levels.ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
