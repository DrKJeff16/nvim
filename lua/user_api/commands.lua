---@class User.Commands.CmdSpec
---@field [1] fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@field [2]? vim.api.keyset.user_command

local INFO = vim.log.levels.INFO
local desc = require('user_api.maps').desc

---@class User.Commands
local Commands = {}

Commands.commands = {} ---@type table<string, User.Commands.CmdSpec>

Commands.commands.Redir = {
  function(ctx)
    local l =
      vim.split(vim.api.nvim_exec2(ctx.args, { output = true }).output, '\n', { plain = true })
    local bufnr = vim.api.nvim_create_buf(true, true)
    local win = vim.api.nvim_open_win(bufnr, true, { vertical = false })
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, l)

    local buf_opts, win_opts = { buf = bufnr }, { win = win } ---@type vim.api.keyset.option, vim.api.keyset.option
    vim.api.nvim_set_option_value('filetype', 'Redir', buf_opts)
    vim.api.nvim_set_option_value('modified', false, buf_opts)
    vim.api.nvim_set_option_value('number', false, win_opts)
    vim.api.nvim_set_option_value('signcolumn', 'no', win_opts)

    vim.keymap.set('n', 'q', function()
      vim.api.nvim_buf_delete(bufnr, { force = true })
      pcall(vim.api.nvim_win_close, win, true)
    end, { buffer = bufnr })

    vim.schedule(function()
      vim.cmd.wincmd('=')
    end)
  end,
  {
    nargs = '+',
    complete = 'command',
    desc = 'Redirect command output to scratch buffer',
  },
}

Commands.commands.Current = {
  function(ctx)
    local curr = { ---@type { buffer: integer, window: integer, tabpage: integer }
      buffer = vim.api.nvim_get_current_buf(),
      window = vim.api.nvim_get_current_win(),
      tabpage = vim.api.nvim_get_current_tabpage(),
    }
    if #ctx.fargs == 0 then
      vim.notify(
        ('buffer: %s\nwindow: %s\ntabpage %s'):format(curr.buffer, curr.window, curr.tabpage),
        INFO
      )
      return
    end
    local arg = ctx.fargs[1] ---@type 'buffer'|'buf'|'window'|'win'|'tab'|'tabpage'
    if vim.list_contains({ 'buffer', 'buf' }, arg) then
      vim.notify(('%d'):format(curr.buffer), INFO, { title = 'Current Buffer' })
      return
    end
    if vim.list_contains({ 'window', 'win' }, arg) then
      vim.notify(('%d'):format(curr.window), INFO, { title = 'Current Window' })
      return
    end
    if vim.list_contains({ 'tabpage', 'tab' }, arg) then
      vim.notify(('%d'):format(curr.tabpage), INFO, { title = 'Current Tabpage' })
      return
    end

    vim.notify(('(:Current) - Invalid argument `%s`!'):format(arg), vim.log.levels.ERROR)
  end,
  {
    nargs = '?',
    complete = function(_, lead) ---@param lead string
      local args = vim.split(lead, '%s+', { trimempty = false })
      if #args >= 3 then
        return {}
      end
      return { 'buf', 'buffer', 'win', 'window', 'tab', 'tabpage' }
    end,
  },
}

Commands.commands.DeleteInactiveBuffers = {
  function(ctx)
    local notify = ctx.bang ~= nil and ctx.bang or false
    for _, buf in ipairs(vim.fn.getbufinfo()) do
      if vim.tbl_isempty(buf.windows) and buf.listed == 1 and buf.loaded == 1 then
        notify = true
        vim.cmd.bdelete({ buf.bufnr, bang = true })
      end
    end
    if notify then
      vim.notify('Deleted inactive buffers.', vim.log.levels.INFO)
    end
  end,
  { desc = 'Delete listed unmodified buffers out of window', bang = true },
}

---@param name string
---@param cmd fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@param opts? vim.api.keyset.user_command
function Commands.add_command(name, cmd, opts)
  require('user_api.check.exists').validate({
    name = { name, { 'string' } },
    cmd = { cmd, { 'function' } },
    opts = { opts, { 'table', 'nil' }, true },
  })

  local cmnd = { cmd, opts or {} } ---@type User.Commands.CmdSpec
  Commands.setup({ [name] = cmnd })
end

---@param cmds table<string, User.Commands.CmdSpec>
---@overload fun()
function Commands.setup(cmds)
  require('user_api.check.exists').validate({ cmds = { cmds, { 'table', 'nil' }, true } })

  Commands.commands = vim.tbl_deep_extend('keep', cmds or {}, Commands.commands)
  for cmd, T in pairs(Commands.commands) do
    local exec, opts = T[1], T[2] or {}
    vim.api.nvim_create_user_command(cmd, exec, opts)
  end

  require('user_api.config').keymaps.set({
    n = {
      ['<Leader>UC'] = { group = '+Commands' },
      ['<Leader>UCR'] = { ':Redir ', desc('Prompt to `Redir` command', false) },
      ['<M-r>'] = { ':Redir ', desc('Prompt `Redir`', false) },
    },
  })
end

local M = setmetatable(Commands, { ---@type User.Commands
  __index = Commands,
  __newindex = function()
    vim.notify('User.Commands is Read-Only!', vim.log.levels.ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
