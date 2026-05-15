local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO
local User = require('user_api')
local executable = User.check.exists.executable
local desc = User.maps.new_desc
local keyset = User.config.keymaps.set
local validate = User.check.validate

---@param bufnr integer
---@return function cb
local function run_formatter(formatter, bufnr)
  validate({
    formatter = { formatter, { 'string' } },
    bufnr = { bufnr, { 'number' } },
  })

  return function()
    if User.util.optget('modified', 'buf', bufnr) or not executable(formatter) then
      return
    end

    local path = vim.api.nvim_buf_get_name(bufnr)
    path = User.util.rstrip('/', vim.fn.fnamemodify(path, ':p'))
    if vim.fn.filereadable(path) ~= 1 or vim.fn.filewritable(path) ~= 1 then
      return
    end

    local cmd = { formatter, path }
    local sys_obj = vim.system(cmd, { text = true }):wait(10000)
    if sys_obj.code ~= 0 then
      vim.notify((sys_obj.stderr and sys_obj.stderr ~= '') and sys_obj.stderr or 'Failed to format!', ERROR)
      return
    end
    vim.notify('Formatted successfully!', INFO)

    local win = vim.api.nvim_get_current_win()
    local pos = vim.api.nvim_win_get_cursor(win)

    vim.cmd.edit()
    vim.api.nvim_win_set_cursor(win, pos)
  end
end

---@param lang string
---@param bufnr integer
local function set_lang(lang, bufnr)
  validate({
    lang = { lang, { 'string' } },
    bufnr = { bufnr, { 'number' } },
  })

  User.util.ft_set(lang, bufnr)()
end

---@class Config.Autocmds
local M = {}

local augroup = -1 ---@type integer

function M.setup()
  augroup = User.util.autocmd.gen_augroups('User_AU', true)['User_AU']
  User.util.autocmd.au_repeated_events({
    events = { 'BufCreate', 'BufAdd', 'BufNew', 'BufNewFile', 'BufRead' },
    opts_tbl = {
      {
        group = augroup,
        pattern = { '.spacemacs', '*.el' },
        callback = function(ev)
          set_lang('lisp', ev.buf)
        end,
      },
      {
        group = augroup,
        pattern = { '.github/CODEOWNERS' },
        callback = function(ev)
          set_lang('codeowners', ev.buf)
        end,
      },
      {
        group = augroup,
        pattern = { '.clangd' },
        callback = function(ev)
          set_lang('yaml', ev.buf)
        end,
      },
      {
        group = augroup,
        pattern = { '*.h' },
        callback = function(ev)
          set_lang('c', ev.buf)
        end,
      },
    },
  })
  User.util.autocmd.au_repeated_events({
    events = { 'FileType' },
    opts_tbl = {
      {
        pattern = { 'c', 'cpp', 'html', 'markdown', 'yaml' },
        group = augroup,
        callback = function(ev)
          User.util.optset({ tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true }, nil, 'buf', ev.buf)
        end,
      },
      {
        pattern = { 'lua', 'python' },
        group = augroup,
        callback = function(ev)
          local is_lua = User.util.optget('filetype', 'buf', ev.buf) == 'lua'
          if is_lua then
            User.util.optset({ ts = 2, sw = 2, sts = 2, et = true }, nil, 'buf', ev.buf)
          end

          keyset({
            n = {
              ['<leader><C-l>'] = {
                run_formatter(is_lua and 'stylua' or 'isort', ev.buf),
                desc(('Format With `%s`'):format(is_lua and 'stylua' or 'isort'), { buf = ev.buf }),
              },
            },
          }, ev.buf)
        end,
      },
      {
        pattern = { 'help' },
        group = augroup,
        callback = function(ev)
          if User.util.optget('ft', 'buf', ev.buf) == 'help' and User.util.optget('bt', 'buf', ev.buf) ~= 'help' then
            return
          end

          User.util.optset(
            { signcolumn = 'no', number = false, colorcolumn = '', list = false },
            nil,
            'win',
            vim.api.nvim_get_current_win()
          )

          vim.cmd.noh()
          vim.cmd.wincmd('=')

          keyset({ n = { q = { vim.cmd.helpclose, desc('Quit Help', { buf = ev.buf }) } } }, ev.buf)
        end,
      },
      {
        pattern = { 'nvim-undotree', 'startuptime', 'qf', 'oil', 'notify', 'checkhealth' },
        group = augroup,
        callback = function(ev)
          if User.util.optget('filetype', 'buf', ev.buf) == 'checkhealth' then
            User.util.optset(
              { wrap = true, number = false, signcolumn = 'no', list = false, colorcolumn = '' },
              nil,
              'win',
              vim.api.nvim_get_current_win()
            )
          end

          keyset({
            n = {
              q = {
                function()
                  vim.api.nvim_cmd({ cmd = 'bdelete', range = { ev.buf }, bang = true }, { output = false })
                end,
                desc('Quit Buffer', { buf = ev.buf }),
              },
            },
          }, ev.buf)
        end,
      },
    },
  })
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
