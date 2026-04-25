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
    if Util.optget('modified', 'buf', bufnr) or not executable(formatter) then
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
        pattern = { 'c', 'cpp', 'html', 'markdown', 'yaml' },
        group = M.augroup,
        callback = function(ev)
          Util.optset(
            { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
            nil,
            'buf',
            ev.buf
          )
        end,
      },
      {
        pattern = { 'lua', 'python' },
        group = M.augroup,
        callback = function(ev)
          local is_lua = Util.optget('filetype', 'buf', ev.buf) == 'lua'
          if is_lua then
            Util.optset(
              { tabstop = 2, shiftwidth = 2, softtabstop = 2, expandtab = true },
              nil,
              'buf',
              ev.buf
            )
          end

          keyset({
            n = {
              ['<leader><C-l>'] = {
                run_formatter(is_lua and 'stylua' or 'isort', ev.buf),
                desc(('Format With `%s`'):format(is_lua and 'stylua' or 'isort'), true, ev.buf),
              },
            },
          }, ev.buf)
        end,
      },
      {
        pattern = { 'nvim-undotree', 'startuptime', 'qf', 'oil', 'notify', 'checkhealth' },
        group = M.augroup,
        callback = function(ev)
          if Util.optget('filetype', 'buf', ev.buf) == 'checkhealth' then
            Util.optset(
              { wrap = true, number = false, signcolumn = 'no', list = false },
              nil,
              'win',
              vim.api.nvim_get_current_win()
            )
          end

          keyset({
            n = {
              q = {
                function()
                  vim.api.nvim_cmd(
                    { cmd = 'bdelete', range = { ev.buf }, bang = true },
                    { output = false }
                  )
                end,
                desc('Quit Buffer', true, ev.buf),
              },
            },
          })
        end,
      },
      {
        pattern = { 'lazy' },
        group = M.augroup,
        callback = function()
          Util.optset(
            { signcolumn = 'no', number = false },
            nil,
            'win',
            vim.api.nvim_get_current_win()
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
            nil,
            'win',
            vim.api.nvim_get_current_win()
          )

          vim.cmd.noh()
          vim.cmd.wincmd('=')

          keyset({ n = { q = { vim.cmd.helpclose, desc('Close Help', true, ev.buf) } } })
        end,
      },
    },
  })
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
