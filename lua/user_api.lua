local uv = vim.uv or vim.loop

local timer = nil ---@type uv.uv_timer_t|nil
local timer_cb = vim.schedule_wrap(function()
  local logfile = vim.fs.joinpath(vim.fn.stdpath('state'), 'nvim.log')
  local stat = uv.fs_stat(logfile)
  if not stat or stat.size < 1048576 then -- 1GiB
    return
  end

  local fd = uv.fs_open(logfile, 'w', tonumber('644', 8))
  if not fd then
    return
  end

  local ok = uv.fs_ftruncate(fd, 0)
  uv.fs_close(fd)

  if ok then
    vim.notify(('`%s` has been cleared!'):format(logfile), vim.log.levels.INFO)
  end
end)

local function make_timer()
  if timer and timer:is_active() then
    return
  end

  timer = uv.new_timer()
  if not timer then
    return
  end

  timer:start(1000, 900000, timer_cb)

  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = vim.api.nvim_create_augroup('log_autoclear', { clear = true }),
    callback = function()
      if not (timer and timer:is_active()) then
        return
      end

      timer:stop()
      timer = nil
    end,
  })
end

---@class UserAPI
---@field check User.Check
---@field commands User.Commands
---@field config User.Config
---@field distro User.Distro
---@field highlight User.Hl
---@field maps User.Maps
---@field opts User.Opts
---@field pickers User.Pickers
---@field update User.Update
---@field util User.Util
local M = {}

function M.disable_netrw()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

---@param commands? table<string, User.Commands.CmdSpec>
---@param verbose? boolean
function M.setup(commands, verbose)
  require('user_api.check').validate({
    commands = { commands, { 'table', 'nil' }, true },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  if verbose == nil then
    verbose = false
  end

  require('user_api.commands').setup(commands or {})
  require('user_api.update').setup()

  require('user_api.opts').setup()
  require('user_api.distro').setup(verbose)

  require('user_api.config').neovide.setup()
  require('user_api.pickers').setup()

  local desc = require('user_api.maps').new_desc
  require('user_api.config').keymaps.set({
    n = {
      ['<leader>U'] = { group = '+User API' },
      ['<leader><leader>'] = { require('user_api.pickers').run, desc('Select Picker') },
    },
  })

  make_timer()
end

local User = setmetatable(M, { ---@type UserAPI
  __index = function(self, k)
    if require('user_api.check').module('user_api.' .. k) then
      return require('user_api.' .. k)
    end
    return rawget(self, k) or nil
  end,
})

return User
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
