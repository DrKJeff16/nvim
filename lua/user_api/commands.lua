---@class User.Commands.CmdSpec
---@field [1] fun(ctx: vim.api.keyset.create_user_command.command_args)
---@field [2]? vim.api.keyset.user_command

---@class User.Commands.AddCommandSpec
---@field callback fun(ctx: vim.api.keyset.create_user_command.command_args)
---@field opts? vim.api.keyset.user_command
---@field verbose? boolean

local INFO = vim.log.levels.INFO
local validate = require('user_api.check').validate

---@class User.Commands
local M = {}

---@param txt? string
---@param bang? boolean
---@param nargs? integer|'+'|'?'|'*'
---@param complete? string|fun(a: string, b: string, c: integer): items: string[]
---@param bar? boolean
---@return vim.api.keyset.user_command opts
function M.desc(txt, bang, nargs, complete, bar)
  validate({
    txt = { txt, { 'string', 'nil' }, true },
    bang = { bang, { 'boolean', 'nil' }, true },
    nargs = { nargs, { 'number', 'string', 'nil' }, true },
    complete = { complete, { 'string', 'function', 'nil' }, true },
    bar = { bar, { 'boolean', 'nil' }, true },
  })
  txt = (txt and txt ~= '') and txt or nil
  if bang == nil then
    bang = false
  end
  if bar == nil then
    bar = false
  end

  local opts = { bang = bang, bar = bar, force = true } ---@type vim.api.keyset.user_command
  if txt and txt ~= '' then
    opts.desc = txt
  end
  if nargs then
    if type(nargs) == 'number' then
      assert(require('user_api.check').is_int(nargs), ('`nargs` is not an integer: `%d`'):format(nargs))
      assert(nargs > 0, ('`nargs` is not a valid integer: `%d`'):format(nargs))
    elseif type(nargs) == 'string' then
      assert(
        vim.list_contains({ '+', '*', '?' }, nargs),
        ("`nargs` is not a valid string (`'*'`, `'?'`, `'+'`): `%s`"):format(nargs)
      )
    end
    opts.nargs = nargs
  end
  if complete then
    opts.complete = complete
  end
  return opts
end

local commands = { ---@type table<string, User.Commands.CmdSpec>
  Current = {
    function(ctx)
      local curr = { ---@type { buffer: integer, window: integer, tabpage: integer }
        buffer = vim.api.nvim_get_current_buf(),
        window = vim.api.nvim_get_current_win(),
        tabpage = vim.api.nvim_get_current_tabpage(),
      }
      if #ctx.fargs == 0 then
        vim.notify(('buffer: %s\nwindow: %s\ntabpage %s'):format(curr.buffer, curr.window, curr.tabpage), INFO)
        return
      end

      local arg = ctx.fargs[1] ---@type 'buffer'|'buf'|'window'|'win'|'tab'|'tabpage'
      if not vim.list_contains({ 'buffer', 'buf', 'window', 'win', 'tabpage', 'tab' }, arg) then
        vim.notify(('(:Current) - Invalid argument `%s`!'):format(arg), vim.log.levels.ERROR)
      else
        local is_buf = vim.list_contains({ 'buffer', 'buf' }, arg)
        local is_win = vim.list_contains({ 'window', 'win' }, arg)
        local is_tab = vim.list_contains({ 'tabpage', 'tab' }, arg)
        local msg = ('%d'):format(is_buf and curr.buffer or (is_win and curr.window or (is_tab and curr.tabpage or '')))
        local title = is_buf and 'Current Buffer'
          or (is_win and 'Current Window' or (is_tab and 'Current Tabpage' or ''))

        vim.notify(msg, INFO, { title = title })
      end
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
    end, true),
  },
  DeleteInactiveBuffers = {
    function(ctx)
      for _, buf in ipairs(vim.fn.getbufinfo()) do
        if #buf.windows == 0 and buf.listed == 1 and buf.loaded == 1 then
          ctx.bang = true
          pcall(vim.cmd.bdelete, { args = { tostring(buf.bufnr) }, bang = ctx.bang })
        end
      end
      if ctx.bang then
        vim.notify('Deleted inactive buffers.', INFO)
      end
    end,
    M.desc('Delete listed unmodified buffers out of window', true),
  },
  ErrQuit = {
    function()
      vim.api.nvim_exec_autocmds('VimLeavePre', {})
      os.exit(1)
    end,
    M.desc('Exit with exit code of 1'),
  },
  Redir = {
    function(ctx)
      local bufnr = vim.api.nvim_create_buf(true, true)
      vim.api.nvim_buf_set_lines(
        bufnr,
        0,
        -1,
        false,
        vim.split(vim.api.nvim_exec2(ctx.args, { output = true }).output, '\n', { trimempty = false })
      )

      local win ---@type integer
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

      local optset = require('user_api.util').optset
      optset('filetype', 'Redir', 'buf', bufnr)
      optset('modified', false, 'buf', bufnr)
      optset('number', false, 'win', win)
      optset('signcolumn', 'no', 'win', win)
      optset('list', false, 'win', win)

      vim.keymap.set('n', 'q', function()
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        pcall(vim.api.nvim_win_close, win, true)
      end, { buffer = bufnr })

      vim.cmd.wincmd('=')
    end,
    M.desc('Redirect command output to scratch buffer', true, '+', 'command'),
  },
}

---@param name_or_cmds string|table<string, User.Commands.AddCommandSpec>
---@param cmd fun(ctx: vim.api.keyset.create_user_command.command_args)
---@param opts vim.api.keyset.user_command
---@param verbose boolean
---@overload fun(name_or_cmds: string, cmd: fun(ctx: vim.api.keyset.create_user_command.command_args))
---@overload fun(name_or_cmds: string, cmd: fun(ctx: vim.api.keyset.create_user_command.command_args), opts: vim.api.keyset.user_command)
---@overload fun(name_or_cmds: table<string, User.Commands.AddCommandSpec>)
function M.add_command(name_or_cmds, cmd, opts, verbose)
  validate({ name_or_cmds = { name_or_cmds, { 'string', 'table' } } })

  if type(name_or_cmds) == 'string' then
    validate({
      cmd = { cmd, { 'function' } },
      opts = { opts, { 'table', 'nil' }, true },
      verbose = { verbose, { 'boolean', 'nil' }, true },
    })
    if verbose == nil then
      verbose = false
    end

    M.setup({ [name_or_cmds] = { cmd, opts or {} } }, verbose)
  else
    for command, options in pairs(name_or_cmds) do
      validate({
        command = { command, { 'string' } },
        options = { options, { 'table' } },
        ['options.callback'] = { options.callback, { 'function' } },
        ['options.opts'] = { options.opts, { 'table', 'nil' }, true },
        ['options.verbose'] = { options.verbose, { 'boolean', 'nil' }, true },
      })
      if options.verbose == nil then
        options.verbose = false
      end

      M.setup({ [command] = { options.callback, options.opts or {} } }, options.verbose)
    end
  end
end

---@param cmds table<string, User.Commands.CmdSpec>
---@param verbose boolean
---@overload fun()
---@overload fun(cmds: table<string, User.Commands.CmdSpec>)
---@overload fun(cmds: nil, verbose: boolean)
---@overload fun(cmds: table<string, User.Commands.CmdSpec>, verbose: boolean)
function M.setup(cmds, verbose)
  validate({
    cmds = { cmds, { 'table', 'nil' }, true },
    verbose = { verbose, { 'boolean', 'nil' }, true },
  })
  if verbose == nil then
    verbose = false
  end

  commands = vim.tbl_deep_extend('force', commands, cmds or {}) --[[@as table<string, User.Commands.CmdSpec>]]
  for cmd, T in pairs(commands) do
    vim.api.nvim_create_user_command(cmd, T[1], T[2] or {})
    if verbose then
      vim.notify(('(User API): Created command `:%s`'):format(cmd), INFO)
    end
  end

  local desc = require('user_api.maps').desc
  require('user_api.config').keymaps.set({
    n = {
      ['<Leader>UC'] = { group = '+Commands' },
      ['<Leader>UCR'] = { ':Redir ', desc('Prompt to `Redir` command', { silent = false }) },
      ['<M-r>'] = { ':Redir ', desc('Prompt `Redir`', { silent = false }) },
    },
  })
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
