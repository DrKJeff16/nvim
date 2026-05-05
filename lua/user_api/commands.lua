---@class User.Commands.CmdSpec
---@field [1] fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@field [2]? vim.api.keyset.user_command

local INFO = vim.log.levels.INFO
local ERROR = vim.log.levels.ERROR
local desc = require('user_api.maps').new_desc
local validate = require('user_api.check').validate

---@class User.Commands
local M = {}

---@param txt? string
---@param bang? boolean
---@param nargs? integer|'+'|'?'|'*'
---@param complete? string|fun(a: string, b: string, c: integer): items: string[]
---@return vim.api.keyset.user_command opts
function M.desc(txt, bang, nargs, complete)
  validate({
    txt = { txt, { 'string', 'nil' }, true },
    bang = { bang, { 'boolean', 'nil' }, true },
    nargs = { nargs, { 'number', 'string', 'nil' }, true },
    complete = { complete, { 'string', 'function', 'nil' }, true },
  })
  txt = (txt and txt ~= '') and txt or nil
  if bang == nil then
    bang = false
  end

  local opts = { bang = bang, force = true } ---@type vim.api.keyset.user_command
  if txt and txt ~= '' then
    opts.desc = txt
  end
  if nargs then
    if type(nargs) == 'number' and require('user_api.check').is_int(nargs) and nargs < 0 then
      error(('`nargs` is not a valid integer: `%s`'):format(nargs), ERROR)
    end
    if type(nargs) == 'string' and not vim.list_contains({ '+', '*', '?' }, nargs) then
      error(("`nargs` is not a valid string (`'*'`, `'?'`, `'+'`): `%s`"):format(nargs), ERROR)
    end
    opts.nargs = nargs
  end
  if complete then
    opts.complete = complete
  end
  return opts
end

M.commands = {} ---@type table<string, User.Commands.CmdSpec>

M.commands.Redir = {
  function(ctx)
    local l =
      vim.split(vim.api.nvim_exec2(ctx.args, { output = true }).output, '\n', { plain = true, trimempty = false })
    local bufnr = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, l)

    local win
    if ctx.bang then
      win = vim.api.nvim_open_win(bufnr, true, { vertical = false })
    else
      local width = math.floor(vim.o.columns * 0.75)
      local height = math.floor(vim.o.lines * 0.85)
      win = vim.api.nvim_open_win(bufnr, true, {
        border = 'single',
        height = height,
        width = width,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2) - 1,
        focusable = true,
        relative = 'editor',
        style = 'minimal',
        title = ctx.args,
        title_pos = 'center',
        zindex = 100,
      })
    end

    local buf_opts, win_opts = { buf = bufnr }, { win = win } ---@type vim.api.keyset.option, vim.api.keyset.option
    vim.api.nvim_set_option_value('filetype', 'Redir', buf_opts)
    vim.api.nvim_set_option_value('modified', false, buf_opts)
    vim.api.nvim_set_option_value('number', false, win_opts)
    vim.api.nvim_set_option_value('signcolumn', 'no', win_opts)
    vim.api.nvim_set_option_value('list', false, win_opts)

    vim.keymap.set('n', 'q', function()
      pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
      pcall(vim.api.nvim_win_close, win, true)
    end, { buffer = bufnr })

    vim.cmd.wincmd('=')
  end,
  M.desc('Redirect command output to scratch buffer', true, '+', 'command'),
}

M.commands.Current = {
  function(ctx)
    local curr = { ---@type { buffer: integer, window: integer, tabpage: integer }
      buffer = vim.api.nvim_get_current_buf(),
      window = vim.api.nvim_get_current_win(),
      tabpage = vim.api.nvim_get_current_tabpage(),
    }
    if vim.tbl_isempty(ctx.fargs) then
      vim.notify(('buffer: %s\nwindow: %s\ntabpage %s'):format(curr.buffer, curr.window, curr.tabpage), INFO)
      return
    end

    local arg = ctx.fargs[1] ---@type 'buffer'|'buf'|'window'|'win'|'tab'|'tabpage'
    if not vim.list_contains({ 'buffer', 'buf', 'window', 'win', 'tabpage', 'tab' }, arg) then
      vim.notify(('(:Current) - Invalid argument `%s`!'):format(arg), ERROR)
      return
    end

    local msg, title = '', ''
    if vim.list_contains({ 'buffer', 'buf' }, arg) then
      msg = ('%d'):format(curr.buffer)
      title = 'Current Buffer'
    elseif vim.list_contains({ 'window', 'win' }, arg) then
      msg = ('%d'):format(curr.window)
      title = 'Current Window'
    elseif vim.list_contains({ 'tabpage', 'tab' }, arg) then
      msg = ('%d'):format(curr.tabpage)
      title = 'Current Tabpage'
    end

    vim.notify(msg, INFO, { title = title })
  end,
  M.desc('', false, '?', function(_, lead)
    local args = vim.split(lead, '%s+', { trimempty = false })
    table.remove(args, 1)

    if #args ~= 1 then
      return {}
    end

    local comp = {} ---@type string[]
    for _, choice in ipairs({ 'buf', 'buffer', 'win', 'window', 'tab', 'tabpage' }) do
      if vim.startswith(choice, args[1]) then
        table.insert(comp, choice)
      end
    end
    return comp
  end),
}

M.commands.DeleteInactiveBuffers = {
  function(ctx)
    for _, buf in ipairs(vim.fn.getbufinfo()) do
      if vim.tbl_isempty(buf.windows) and buf.listed == 1 and buf.loaded == 1 then
        ctx.bang = true
        vim.cmd.bdelete({ buf.bufnr, bang = true })
      end
    end
    if ctx.bang then
      vim.notify('Deleted inactive buffers.', vim.log.levels.INFO)
    end
  end,
  M.desc('Delete listed unmodified buffers out of window', true),
}

---@param name string
---@param cmd fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@param opts? vim.api.keyset.user_command
function M.add_command(name, cmd, opts)
  validate({
    name = { name, { 'string' } },
    cmd = { cmd, { 'function' } },
    opts = { opts, { 'table', 'nil' }, true },
  })

  local cmnd = { cmd, opts or {} } ---@type User.Commands.CmdSpec
  M.setup({ [name] = cmnd })
end

---@param cmds? table<string, User.Commands.CmdSpec>
function M.setup(cmds)
  validate({ cmds = { cmds, { 'table', 'nil' }, true } })

  M.commands = vim.tbl_deep_extend('keep', cmds or {}, M.commands)
  for cmd, T in pairs(M.commands) do
    local exec, opts = T[1], T[2] or {}
    vim.api.nvim_create_user_command(cmd, exec, opts)
  end

  require('user_api.config.keymaps').set({
    n = {
      ['<Leader>UC'] = { group = '+Commands' },
      ['<Leader>UCR'] = { ':Redir ', desc('Prompt to `Redir` command', { silent = false }) },
      ['<M-r>'] = { ':Redir ', desc('Prompt `Redir`', { silent = false }) },
    },
  })
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
