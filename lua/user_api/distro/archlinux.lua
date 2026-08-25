---Modify runtimepath to also search the system-wide Vim directory
---(e.g. for Vim runtime files from Arch Linux packages)

local RTPATHS = {
  '/usr/share/vim/vimfiles/after',
  '/usr/share/vim/vimfiles',
  '/usr/share/nvim/runtime',
  '/usr/local/share/vim/vimfiles/after',
  '/usr/local/share/vim/vimfiles',
  '/usr/local/share/nvim/runtime',
}

---@class User.Distro.Archlinux
local M = {}

function M.is_distro()
  -- First check for each dir's existance
  local new_rtpaths = {} ---@type string[]
  for _, p in ipairs(RTPATHS) do
    if vim.fn.isdirectory(p) == 1 and not vim.list_contains(new_rtpaths, p) then
      table.insert(new_rtpaths, p)
    end
  end
  if vim.tbl_isempty(new_rtpaths) then
    return false
  end

  RTPATHS = vim.deepcopy(new_rtpaths)
  return true
end

function M.setup()
  if M.is_distro() then
    for _, path in ipairs(RTPATHS) do
      if vim.fn.isdirectory(path) == 1 then
        vim.o.runtimepath = vim.o.runtimepath .. ',' .. path
      end
    end
    pcall(vim.cmd.runtime, { args = { 'archlinux.vim' }, bang = true })
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
