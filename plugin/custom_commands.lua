if vim.g.custom_commands_loaded == 1 then
  return
end

vim.g.custom_commands_loaded = 1

local User = require('user_api')

---@param path string
---@return function callback
local function open_file(path)
  path = vim.fn.fnamemodify(path, ':p')

  return function()
    assert(vim.fn.isdirectory(path) ~= 1, 'Refusing to edit directory!')

    local parent = vim.fn.fnameescape(vim.fn.fnamemodify(path, ':p:h'))
    local ok ---@type boolean
    if package.loaded['project'] ~= nil then
      ok = require('project').set_pwd({ dir = parent, method = 'custom' })
      if not ok then
        ok = pcall(vim.api.nvim_set_current_dir, parent)
      end
    else
      ok = pcall(vim.api.nvim_set_current_dir, parent)
    end

    if not ok then
      return
    end

    assert(vim.fn.fnameescape(vim.fn.fnamemodify(path, ':p:t')) ~= '', 'Cannot edit empty target!')
    assert(
      (pcall(vim.cmd.tabedit, { args = { vim.fn.fnameescape(vim.fn.fnamemodify(path, ':p:t')) } })),
      ('Unable to edit `%s`'):format(vim.fn.fnamemodify(path, ':~'))
    )

    if #vim.api.nvim_list_tabpages() < 1 then
      return
    end

    local bufnr, target_tab = vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_tabpage()
    vim.api.nvim_create_autocmd('BufDelete', {
      group = vim.api.nvim_create_augroup('Bashrc', { clear = true }),
      buffer = bufnr,
      once = true,
      callback = function()
        if #vim.api.nvim_list_tabpages() > 1 and vim.api.nvim_get_current_tabpage() == target_tab then
          pcall(vim.cmd.tabclose)
        end
      end,
    })
  end
end

if User.check.is_windows() then
  return
end

local HOME = vim.fn.environ()['HOME'] or vim.fn.expand('~')
User.commands.add_command({
  Bashrc = { callback = open_file(vim.fs.joinpath(HOME, '.bashrc')) },
  Edals = { callback = open_file(vim.fs.joinpath(HOME, '.bash_aliases')) },
  Edcomp = { callback = open_file(vim.fs.joinpath(HOME, '.bash_completion')) },
  Edfc = { callback = open_file(vim.fs.joinpath(HOME, '.bash_functions')) },
  Nvimrc = { callback = open_file(vim.fs.joinpath(vim.fn.stdpath('config'), 'init.lua')) },
  Vimrc = { callback = open_file(vim.fs.joinpath(HOME, '.vimrc')) },
})
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
