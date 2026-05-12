--- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Termux packages)

local function is_dir(dir) ---@param dir string
  return vim.fn.isdirectory(dir) == 1
end

---@class User.Distro.Termux
---@field PREFIX string
---@field rtpaths string[]
local M = {}

M.PREFIX = vim.fn.has_key(vim.fn.environ(), 'PREFIX') and vim.fn.environ().PREFIX or ''

M.RTPATHS = {
  vim.fs.joinpath(M.PREFIX, 'share/vim/vimfiles/after'),
  vim.fs.joinpath(M.PREFIX, 'share/vim/vimfiles'),
  vim.fs.joinpath(M.PREFIX, 'share/nvim/runtime'),
  vim.fs.joinpath(M.PREFIX, 'local/share/vim/vimfiles/after'),
  vim.fs.joinpath(M.PREFIX, 'local/share/vim/vimfiles'),
  vim.fs.joinpath(M.PREFIX, 'local/share/nvim/runtime'),
}

function M.is_distro()
  if M.PREFIX == '' or not is_dir(M.PREFIX) then
    return false
  end

  for i, path in ipairs(M.rtpaths) do
    if not is_dir(path) then
      table.remove(M.rtpaths, i)
    end
  end
  return not require('user_api.check.value').empty(M.rtpaths)
end

function M.setup()
  if not (M.is_distro() and is_dir(M.PREFIX)) then
    return
  end
  for _, path in ipairs(M.rtpaths) do
    if is_dir(path) == 1 then
      vim.o.rtp = vim.o.rtp .. ',' .. path
    end
  end
  vim.api.nvim_set_option_value('wrap', true, { scope = 'global' })
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
