---Modify runtimepath to also search the system-wide Vim directory
---(e.g. for Vim runtime files from Arch Linux packages)

local ERROR = vim.log.levels.ERROR

local function is_dir(dir) ---@param dir string
  return vim.fn.isdirectory(dir) == 1
end

---@class User.Distro.Archlinux
local Archlinux = {}

local RTPATHS = { ---@type string[]
  '/usr/share/vim/vimfiles/after',
  '/usr/share/vim/vimfiles',
  '/usr/share/nvim/runtime',
  '/usr/local/share/vim/vimfiles/after',
  '/usr/local/share/vim/vimfiles',
  '/usr/local/share/nvim/runtime',
}

Archlinux.rtpaths = setmetatable(RTPATHS, { ---@type string[]
  __index = RTPATHS,
  __newindex = function()
    vim.notify('User.Distro.Archlinux.rtpaths is Read-Only!', ERROR)
  end,
})

function Archlinux.validate()
  -- First check for each dir's existance
  local new_rtpaths = {} ---@type string[]
  for _, p in ipairs(Archlinux.rtpaths) do
    if vim.fn.isdirectory(p) == 1 and not vim.list_contains(new_rtpaths, p) then
      table.insert(new_rtpaths, p)
    end
  end
  if vim.tbl_isempty(new_rtpaths) then
    return false
  end

  Archlinux.rtpaths = vim.deepcopy(new_rtpaths)
  return true
end

function Archlinux.setup()
  if not Archlinux.validate() then
    return
  end
  for _, path in ipairs(Archlinux.rtpaths) do
    if is_dir(path) then
      vim.o.runtimepath = vim.o.runtimepath .. ',' .. path
    end
  end
  pcall(vim.cmd.runtime, { 'archlinux.vim', bang = true })
end

local M = setmetatable({}, { ---@type User.Distro.Archlinux
  __index = Archlinux,
  __newindex = function()
    vim.notify('User.Distro.Archlinux is Read-Only!', ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
