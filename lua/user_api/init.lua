local Util = require('user_api.util')

---@generic T: table, F
---@param t T
---@param k any
---@param fallback F
---@return F fallback
local function get(t, k, fallback)
  return Util.get(t, k, function()
    return Util.rawset(t, k, fallback)
  end, true)
end

local timer = nil ---@type uv.uv_timer_t|nil|?

local function make_timer()
  if timer and timer:is_active() then
    return
  end

  local uv = vim.uv or vim.loop
  timer = assert(uv.new_timer(), 'Unable to create timer')
  timer:start(
    1000,
    900000,
    vim.schedule_wrap(function()
      local logfile = vim.fs.joinpath(vim.fn.stdpath('state'), 'nvim.log')
      local stat = assert(uv.fs_stat(logfile), 'Unable to get stats for logfile')
      if stat.size < math.floor(1048576 / 2) then -- 512MiB
        return
      end

      local fd = assert(uv.fs_open(logfile, 'w', tonumber('644', 8)), 'Unable to open logfile')
      if uv.fs_ftruncate(fd, 0) then
        vim.notify(('`%s` has been cleared!'):format(logfile), vim.log.levels.INFO)
      end
      assert(uv.fs_close(fd), ('Unable to close file descriptor for logfile: `%s`'):format(logfile))
    end)
  )

  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = vim.api.nvim_create_augroup('UserAPI', { clear = false }),
    once = true,
    callback = function()
      if timer and timer:is_active() then
        assert(timer:stop() ~= nil, 'Unable to stop Neovim logfile cleanup timer')
        timer = nil
      end
    end,
  })
end

---@class UserAPI
---@field backtrace fun(lvl: 0|1|2|3|4, ...: any)
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

setmetatable(M, {
  __index = function(self, k) ---@param self UserAPI
    local raw = Util.get(self, k)
    if raw ~= nil then
      return raw
    end

    if type(k) ~= 'string' then
      return
    end

    ---@cast k string
    if require('user_api.check').module('user_api.' .. k) then
      return get(self, k, require('user_api.' .. k))
    end
  end,
})

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

  M.commands.setup(commands or {}, verbose)
  M.update.setup(verbose)
  M.opts.setup(nil, verbose)
  M.distro.setup(verbose)
  M.config.neovide.setup(nil, nil, verbose)
  M.pickers.setup(verbose)

  M.config.keymaps.set({
    n = {
      ['<leader>U'] = { group = '+User API' },
      ['<leader><leader>'] = { M.pickers.run, M.maps.desc('Select Picker') },
    },
  })

  M.util.notify.setup()

  make_timer()

  vim.filetype.add({
    extension = { el = 'lisp', h = 'c', sh = 'bash' },
    filename = {
      ['.clangd'] = 'yaml',
      ['.github/CODEOWNERS'] = 'codeowners',
      [vim.fn.expand('~/.spacemacs')] = 'lisp',
    },
  })
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
