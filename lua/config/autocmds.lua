local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO
local Util = require('user_api.util')
local au = require('user_api.util.autocmd')
local executable = require('user_api.check.exists').executable
local desc = require('user_api.maps').desc
local keyset = require('user_api.config.keymaps').set
local validate = require('user_api.check').validate

---@param bufnr integer
---@return function cb
local function run_formatter(formatter, bufnr)
  validate({
    formatter = { formatter, { 'string' } },
    bufnr = { bufnr, { 'number' } },
  })

  return function()
    if Util.optget('modified', { buf = bufnr }).modified or not executable(formatter) then
      return
    end

    local path = vim.api.nvim_buf_get_name(bufnr)
    path = Util.rstrip('/', vim.fn.fnamemodify(path, ':p'))
    if vim.fn.filereadable(path) ~= 1 or vim.fn.filewritable(path) ~= 1 then
      return
    end

    local cmd = { formatter, path }
    local sys_obj = vim.system(cmd, { text = true }):wait(10000)
    if sys_obj.code ~= 0 then
      vim.notify(
        (sys_obj.stderr and sys_obj.stderr ~= '') and sys_obj.stderr or 'Failed to format!',
        ERROR
      )
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

  Util.ft_set(lang, bufnr)()
end

---@class Config.Autocmds
local M = {}

M.augroup = -1 ---@type integer

function M.setup()
  M.augroup = au.gen_augroups('User_AU', true)['User_AU']
  au.au_repeated_events({
    events = { 'BufCreate', 'BufAdd', 'BufNew', 'BufNewFile', 'BufRead' },
    opts_tbl = {
      {
        group = M.augroup,
        pattern = { '.spacemacs', '*.el' },
        callback = function(ev)
          set_lang('lisp', ev.buf)
        end,
      },
      {
        group = M.augroup,
        pattern = { '.github/CODEOWNERS' },
        callback = function(ev)
          set_lang('codeowners', ev.buf)
        end,
      },
      {
        group = M.augroup,
        pattern = { '.clangd' },
        callback = function(ev)
          set_lang('yaml', ev.buf)
        end,
      },
      {
        group = M.augroup,
        pattern = { '*.h' },
        callback = function(ev)
          set_lang('c', ev.buf)
        end,
      },
    },
  })
  au.au_repeated_events({
    events = { 'FileType' },
    opts_tbl = {
      {
        pattern = 'checkhealth',
        group = M.augroup,
        callback = function(ev)
          Util.optset(
            { wrap = true, number = false, signcolumn = 'no', list = false },
            { win = vim.api.nvim_get_current_win() }
          )

          vim.keymap.set('n', 'q', function()
            vim.api.nvim_cmd(
              { cmd = 'bdelete', range = { ev.buf }, bang = true },
              { output = false }
            )
          end, { buffer = ev.buf })
        end,
      },
      {
        pattern = { 'c', 'cpp', 'html', 'markdown', 'yaml' },
        group = M.augroup,
        callback = function(ev)
          Util.optset(
            { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
            { buf = ev.buf }
          )
        end,
      },
      {
        pattern = { 'lua' },
        group = M.augroup,
        callback = function(ev)
          Util.optset(
            { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
            { buf = ev.buf }
          )

          keyset({
            n = {
              ['<leader><C-l>'] = { run_formatter('stylua', ev.buf), desc('Format With `stylua`') },
            },
          }, ev.buf)
        end,
      },
      {
        pattern = { 'python' },
        group = M.augroup,
        callback = function(ev)
          keyset({
            n = {
              ['<leader><C-l>'] = { run_formatter('isort', ev.buf), desc('Format With `isort`') },
            },
          }, ev.buf)
        end,
      },
      {
        pattern = { 'nvim-undotree', 'startuptime', 'qf' },
        group = M.augroup,
        callback = function(ev)
          vim.keymap.set('n', 'q', function()
            vim.api.nvim_cmd(
              { cmd = 'bdelete', range = { ev.buf }, bang = true },
              { output = false }
            )
          end, { buffer = ev.buf })
        end,
      },
      {
        pattern = { 'lazy' },
        group = M.augroup,
        callback = function()
          Util.optset(
            { signcolumn = 'no', number = false },
            { win = vim.api.nvim_get_current_win() }
          )
        end,
      },
      {
        pattern = { 'help' },
        group = M.augroup,
        callback = function(ev)
          if Util.bt_get(ev.buf) ~= 'help' then
            return
          end
          Util.optset(
            { signcolumn = 'no', number = false, wrap = true, colorcolumn = '' },
            { win = vim.api.nvim_get_current_win() }
          )

          vim.cmd.noh()
          vim.cmd.wincmd('=')

          vim.keymap.set('n', 'q', vim.cmd.helpclose, { buffer = ev.buf })
        end,
      },
      {
        pattern = { 'ministarter' },
        group = M.augroup,
        callback = function(ev)
          vim.keymap.set('n', 'q', vim.cmd.quit, { buffer = ev.buf })
        end,
      },
      {
        pattern = { 'man' },
        group = M.augroup,
        callback = function(ev)
          if Util.bt_get(ev.buf) ~= 'nofile' then
            return
          end
          vim.keymap.set('n', 'q', vim.cmd.quitall, { buffer = ev.buf })
        end,
      },
    },
  })
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
