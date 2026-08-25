--- Modify runtimepath to also search the system-wide Vim directory
-- (eg. for Vim runtime files from Termux packages)

local PREFIX = vim.fn.has_key(vim.fn.environ(), 'PREFIX') and vim.fn.environ().PREFIX or ''
local RTPATHS = {
  vim.fs.joinpath(PREFIX, 'share/vim/vimfiles/after'),
  vim.fs.joinpath(PREFIX, 'share/vim/vimfiles'),
  vim.fs.joinpath(PREFIX, 'share/nvim/runtime'),
  vim.fs.joinpath(PREFIX, 'local/share/vim/vimfiles/after'),
  vim.fs.joinpath(PREFIX, 'local/share/vim/vimfiles'),
  vim.fs.joinpath(PREFIX, 'local/share/nvim/runtime'),
}

---@class User.Distro.Termux
local M = {}

function M.is_distro()
  if PREFIX == '' or not vim.fn.isdirectory(PREFIX) == 1 then
    return false
  end

  for i, path in ipairs(RTPATHS) do
    if not vim.fn.isdirectory(path) == 1 then
      table.remove(RTPATHS, i)
    end
  end
  return not require('user_api.check.value').empty(RTPATHS)
end

function M.setup()
  if M.is_distro() and vim.fn.isdirectory(PREFIX) == 1 then
    for _, path in ipairs(RTPATHS) do
      if vim.fn.isdirectory(path) == 1 then
        vim.o.rtp = vim.o.rtp .. ',' .. path
      end
    end
    vim.api.nvim_set_option_value('wrap', true, { scope = 'global' })
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
