--- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Termux packages)

local function is_dir(dir) ---@param dir string
  return vim.fn.isdirectory(dir) == 1
end

---@class User.Distro.Termux
local Termux = {}

Termux.PREFIX = vim.fn.has_key(vim.fn.environ(), 'PREFIX') and vim.fn.environ().PREFIX or '' ---@type string

local RTPATHS = {
  vim.fs.joinpath(Termux.PREFIX, 'share/vim/vimfiles/after'),
  vim.fs.joinpath(Termux.PREFIX, 'share/vim/vimfiles'),
  vim.fs.joinpath(Termux.PREFIX, 'share/nvim/runtime'),
  vim.fs.joinpath(Termux.PREFIX, 'local/share/vim/vimfiles/after'),
  vim.fs.joinpath(Termux.PREFIX, 'local/share/vim/vimfiles'),
  vim.fs.joinpath(Termux.PREFIX, 'local/share/nvim/runtime'),
}

Termux.rtpaths = setmetatable(RTPATHS, { ---@type string[]
  __index = RTPATHS,
  __newindex = function()
    vim.notify('User.Distro.Termux.rtpaths is Read-Only!', vim.log.levels.ERROR)
  end,
})

function Termux.validate()
  if Termux.PREFIX == '' or not is_dir(Termux.PREFIX) then
    return false
  end

  local new_rtpaths = {} ---@type string[]
  for _, path in ipairs(Termux.rtpaths) do
    if is_dir(path) then
      table.insert(new_rtpaths, path)
    end
  end
  if require('user_api.check.value').empty(new_rtpaths) then
    return false
  end

  Termux.rtpaths = vim.deepcopy(new_rtpaths)
  return true
end

function Termux.setup()
  if not (Termux.validate() and is_dir(Termux.PREFIX)) then
    return
  end
  for _, path in ipairs(Termux.rtpaths) do
    if is_dir(path) == 1 then
      vim.o.rtp = vim.o.rtp .. ',' .. path
    end
  end
  vim.api.nvim_set_option_value('wrap', true, { scope = 'global' })
end

local M = setmetatable({}, { ---@type User.Distro.Termux
  __index = Termux,
  __newindex = function()
    vim.notify('User.Distro.Termux is Read-Only!', vim.log.levels.ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
