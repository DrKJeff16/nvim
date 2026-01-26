---@alias User.Keymaps.Delete table<'n'|'i'|'v'|'t'|'o'|'x', string[]>

local VIMRC = vim.fn.stdpath('config') .. '/init.lua'
local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO
local nop = require('user_api.maps').nop
local desc = require('user_api.maps').desc
local ft_get = require('user_api.util').ft_get
local bt_get = require('user_api.util').bt_get

---@param cmd 'edit'|'split'|'vsplit'|'tabnew'
---@return function
local function rcfile(cmd)
  require('user_api.check.exists').validate({ cmd = { cmd, { 'string' } } })

  return function()
    vim.cmd[cmd](VIMRC)
  end
end

---@param check string
---@return function checkhealth_fun
local function gen_checkhealth(check)
  return function()
    vim.cmd.checkhealth(check)
  end
end

---@param vertical boolean
---@overload fun()
local function gen_fun_blank(vertical)
  require('user_api.check.exists').validate({ vertical = { vertical, { 'boolean', 'nil' }, true } })
  vertical = vertical ~= nil and vertical or false

  return function()
    local buf = vim.api.nvim_create_buf(true, false)
    local win = vim.api.nvim_open_win(buf, true, { vertical = vertical })
    vim.api.nvim_set_current_win(win)

    local set_opts = { buf = buf } ---@type vim.api.keyset.option
    vim.api.nvim_set_option_value('filetype', '', set_opts)
    vim.api.nvim_set_option_value('buftype', '', set_opts)
    vim.api.nvim_set_option_value('modifiable', true, set_opts)
    vim.api.nvim_set_option_value('modified', false, set_opts)
  end
end

---@param force boolean|nil
---@overload fun()
local function buf_del(force)
  require('user_api.check.exists').validate({ force = { force, { 'boolean', 'nil' }, true } })
  force = force ~= nil and force or false

  local ft_triggers = { 'NvimTree', 'noice', 'trouble' }
  local pre_exc = { ft = { 'help', 'lazy', 'man', 'noice' }, bt = { 'help' } }
  return function()
    local buf = vim.api.nvim_get_current_buf()
    local prev_ft, prev_bt = ft_get(buf), bt_get(buf)
    if not force then
      force = prev_bt == 'terminal'
    end

    vim.cmd.bdelete({ bang = force })
    if vim.list_contains(pre_exc.ft, prev_ft) or vim.list_contains(pre_exc.bt, prev_bt) then
      return
    end

    if vim.list_contains(ft_triggers, ft_get(vim.api.nvim_get_current_buf())) then
      vim.cmd.bprevious()
    end
  end
end

---@class User.Config.Keymaps
---@field no_oped? boolean
local Keymaps = {}

Keymaps.NOP = require('user_api.config.keymaps.nop')

Keymaps.Keys = { ---@type AllModeMaps
  n = {
    ['<leader>'] = { group = '+Open `which-key`' },
    ['<leader>F'] = { group = '+Folding' },
    ['<leader>H'] = { group = '+Help' },
    ['<leader>Hm'] = { group = '+Man Pages' },
    ['<leader>b'] = { group = '+Buffer' },
    ['<leader>f'] = { group = '+File' },
    ['<leader>fF'] = { group = '+New File' },
    ['<leader>fi'] = { group = '+Indent' },
    ['<leader>fv'] = { group = '+Script Files' },
    ['<leader>q'] = { group = '+Quit Nvim' },
    ['<leader>t'] = { group = '+Tabs' },
    ['<leader>v'] = { group = '+Vim' },
    ['<leader>ve'] = { group = '+Edit Nvim Config File' },
    ['<leader>vh'] = { group = '+Checkhealth' },
    ['<leader>w'] = { proxy = '<C-w>', group = 'Window' },
    ['<leader>U'] = { group = '+User API' },
    ['<leader>UK'] = { group = '+Keymaps' },
    ['<Esc><Esc>'] = { vim.cmd.noh, desc('Remove Highlighted Search') },
    ['<leader>bd'] = { buf_del(), desc('Close Buffer') },
    ['<leader>bD'] = { buf_del(true), desc('Close Buffer Forcefully') },
    ['<leader>bf'] = { vim.cmd.bfirst, desc('Goto First Buffer') },
    ['<leader>bl'] = { vim.cmd.blast, desc('Goto Last Buffer') },
    ['<leader>bn'] = { vim.cmd.bnext, desc('Next Buffer') },
    ['<leader>bp'] = { vim.cmd.bprevious, desc('Previous Buffer') },
    ['<leader>/'] = { ':%s/', desc('Run Search-Replace Prompt For Whole File', false) },
    ['<leader>Fc'] = { ':%foldclose!<CR>', desc('Close All Folds') },
    ['<leader>Fo'] = { ':%foldopen!<CR>', desc('Open All Folds') },
    ['<leader>fFx'] = { gen_fun_blank(), desc('New Horizontal Blank File') },
    ['<leader>fFv'] = { gen_fun_blank(true), desc('New Vertical Blank File') },
    ['<leader>fs'] = { ':w<CR>', desc('Save File') },
    ['<leader>fS'] = { ':w ', desc('Prompt Save File', false) },
    ['<leader>fii'] = {
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        if not vim.api.nvim_get_option_value('modifiable', { buf = bufnr }) then
          vim.notify('Unable to indent. File is not modifiable!', ERROR)
          return
        end

        local win = vim.api.nvim_get_current_win()
        local saved_pos = vim.api.nvim_win_get_cursor(win)
        vim.api.nvim_feedkeys('gg=G', 'n', false)
        vim.schedule(function()
          vim.api.nvim_win_set_cursor(win, saved_pos)
        end)
      end,
      desc('Indent Whole File'),
    },
    ['<leader>fir'] = { ':%retab<CR>', desc('Retab File') },
    ['<leader>fiR'] = { ':%retab!<CR>', desc('Retab File (Forcefully)') },
    ['<leader>fvL'] = { ':luafile ', desc('Source Lua File (Prompt)', false) },
    ['<leader>fvV'] = { ':so ', desc('Source VimScript File (Prompt)', false) },
    ['<leader>fvl'] = { ':luafile %<CR>', desc('Source Current File As Lua File') },
    ['<leader>fvv'] = { ':source %<CR>', desc('Source Current File') },
    ['<leader>vee'] = { rcfile('edit'), desc('Open In Current Window') },
    ['<leader>vex'] = { rcfile('split'), desc('Open In Horizontal Split') },
    ['<leader>vet'] = { rcfile('tabnew'), desc('Open In New Tab') },
    ['<leader>vev'] = { rcfile('vsplit'), desc('Open In Vertical Split') },
    ['<leader>vhh'] = { vim.cmd.checkhealth, desc('Run') },
    ['<leader>vhH'] = { ':checkhealth ', desc('Prompt', false) },
    ['<leader>vhd'] = { gen_checkhealth('vim.health'), desc('`vim.health`') },
    ['<leader>vhl'] = { gen_checkhealth('vim.lsp'), desc('`vim.lsp`') },
    ['<leader>vhp'] = { gen_checkhealth('vim.provider'), desc('`vim.provider`') },
    ['<leader>vs'] = { ':source $MYVIMRC<CR>', desc('Source $MYVIMRC') },
    ['<leader>vhD'] = { gen_checkhealth('vim.deprecated'), desc('`vim.deprecated`') },
    ['<leader>vht'] = { gen_checkhealth('vim.treesitter'), desc('`vim.treesitter`') },
    ['<leader>HT'] = { ':tab help<CR>', desc('Open Help On New Tab') },
    ['<leader>HV'] = { ':vert help<CR>', desc('Open Help On Vertical Split') },
    ['<leader>HX'] = { ':hor help<CR>', desc('Open Help On Horizontal Split') },
    ['<leader>Hh'] = { ':h ', desc('Prompt For Help', false) },
    ['<leader>Ht'] = { ':tab h ', desc('Prompt For Help On New Tab', false) },
    ['<leader>Hv'] = { ':vertical h ', desc('Prompt For Help On Vertical Split', false) },
    ['<leader>Hx'] = { ':horizontal h ', desc('Prompt For Help On Horizontal Split', false) },
    ['<leader>HmM'] = { ':Man ', desc('Prompt For Man', false) },
    ['<leader>HmT'] = { ':tab Man ', desc('Prompt For Man Page (Tab)', false) },
    ['<leader>HmV'] = { ':vert Man ', desc('Prompt For Man Page (Vertical)', false) },
    ['<leader>HmX'] = { ':horizontal Man ', desc('Prompt Man Page (Horizontal)', false) },
    ['<leader>Hmm'] = { ':Man<CR>', desc('Open Manpage For Word Under Cursor') },
    ['<leader>Hmt'] = { ':tab Man<CR>', desc('Open Man Page (Tab)') },
    ['<leader>Hmv'] = { ':vert Man<CR>', desc('Open Man Page (Vertical)') },
    ['<leader>Hmx'] = { ':horizontal Man<CR>', desc('Open Man Page (Horizontal)') },
    ['<C-w>N'] = {
      function()
        local ft = ft_get(vim.api.nvim_get_current_buf())
        vim.cmd.wincmd('n')
        vim.cmd.wincmd('o')

        local opts = { buf = vim.api.nvim_get_current_buf() }
        vim.api.nvim_set_option_value('ft', ft, opts)
        vim.api.nvim_set_option_value('modifiable', true, opts)
        vim.api.nvim_set_option_value('modified', false, opts)
      end,
      desc('New Blank File'),
    },
    ['<C-w><Left>'] = { ':wincmd h<CR>', desc('Go To Window On The Left') },
    ['<C-w><Right>'] = { ':wincmd l<CR>', desc('Go To Window On The Right') },
    ['<C-w><Up>'] = { ':wincmd k<CR>', desc('Go To Window Above') },
    ['<C-w><Down>'] = { ':wincmd j<CR>', desc('Go To Window Below') },
    ['<C-w>n'] = { ':wincmd w<CR>', desc('Next Window') },
    ['<C-w>S'] = { ':wincmd x<CR>', desc('Swap Current With Next') },
    ['<C-w>p'] = { ':wincmd W<CR>', desc('Previous Window') },
    ['<C-w><CR>'] = { ':wincmd o<CR>', desc('Make Current Only Window') },
    ['<C-w>X'] = { ':split ', desc('Horizontal Split (Prompt)', false) },
    ['<C-w>V'] = { ':vsplit ', desc('Vertical Split (Prompt)', false) },
    ['<C-w>|'] = { ':wincmd ^<CR>', desc('Split Current To Edit Alternate File') },
    ['<C-w>W'] = { group = '+Move Window' },
    ['<C-w>W<Up>'] = { ':wincmd K<CR>', desc('Move Window To The Very Top') },
    ['<C-w>W<Down>'] = { ':wincmd J<CR>', desc('Move Window To The Very Bottom') },
    ['<C-w>W<Right>'] = { ':wincmd L<CR>', desc('Move Window To Far Right') },
    ['<C-w>W<Left>'] = { ':wincmd H<CR>', desc('Move Window To Far Left') },
    ['<leader>qQ'] = { ':qa!<CR>', desc('Quit Nvim Forcefully') },
    ['<leader>qq'] = { vim.cmd.quitall, desc('Quit Nvim') },
    ['<leader>qr'] = { ':restart +qall!<CR>', desc('Restart Nvim') },
    ['<leader>tA'] = { vim.cmd.tabnew, desc('New Tab') },
    ['<leader>tD'] = { ':tabclose!<CR>', desc('Close Tab Forcefully') },
    ['<leader>ta'] = { ':tabnew ', desc('New Tab (Prompt)', false) },
    ['<leader>td'] = { vim.cmd.tabclose, desc('Close Tab') },
    ['<leader>tf'] = { vim.cmd.tabfirst, desc('Goto First Tab') },
    ['<leader>tl'] = { vim.cmd.tablast, desc('Goto Last Tab') },
    ['<leader>tn'] = { vim.cmd.tabnext, desc('Next Tab') },
    ['<leader>tp'] = { vim.cmd.tabprevious, desc('Previous Tab') },
    ['<leader>UKp'] = {
      function()
        vim.notify(vim.inspect(Keymaps.Keys), INFO)
      end,
      desc('Print all custom keymaps in their respective modes'),
    },
  },
  v = {
    ['<leader>'] = { group = '+Open `which-key`' },
    ['<leader>f'] = { group = '+File' },
    ['<leader>fF'] = { group = '+Folding' },
    ['<leader>fi'] = { group = '+Indent' },
    ['<leader>h'] = { group = '+Help' },
    ['<leader>q'] = { group = '+Quit Nvim' },
    ['<leader>v'] = { group = '+Vim' },
    ['<leader>S'] = { ':sort!<CR>', desc('Sort Selection (Reverse)') },
    ['<leader>s'] = { ':sort<CR>', desc('Sort Selection') },
    ['<leader>fFo'] = { ':foldopen<CR>', desc('Open Fold') },
    ['<leader>fFc'] = { ':foldclose<CR>', desc('Close Fold') },
    ['<leader>fr'] = { ':s/', desc('Search/Replace Prompt For Selection', false) },
    ['<leader>fir'] = { ':retab<CR>', desc('Retab Selection') },
    ['<leader>fiR'] = { ':retab!<CR>', desc('Retab Selection Forcefully') },
    ['<leader>qQ'] = { ':qa!<CR>', desc('Quit Nvim Forcefully') },
    ['<leader>qq'] = { vim.cmd.quitall, desc('Quit Nvim') },
  },
  t = { ['<Esc>'] = { '<C-\\><C-n>', desc('Escape Terminal') } },
}

---Set both the `<leader>` and `<localleader>` keys.
--- ---
---@param leader string `<leader>` key string (defaults to `<Space>`)
---@param local_leader string `<localleader>` string (defaults to `<Space>`)
---@param force boolean Force leader switch (defaults to `false`)
---@overload fun(leader: string)
---@overload fun(leader: string, local_leader: string)
function Keymaps.set_leader(leader, local_leader, force)
  require('user_api.check.exists').validate({
    leader = { leader, { 'string' } },
    local_leader = { local_leader, { 'string', 'nil' }, true },
    force = { force, { 'boolean', 'nil' }, true },
  })
  leader = leader ~= '' and leader or '<Space>'
  local_leader = (local_leader ~= nil and local_leader ~= '') and local_leader or leader
  force = force ~= nil and force or false
  if vim.g.leader_set and not force then
    return
  end

  local vim_vars = { leader = '', localleader = '' }
  if leader:lower() == '<space>' then
    vim_vars.leader = ' '
  elseif leader == ' ' then
    leader = '<Space>'
    vim_vars.leader = ' '
  else
    vim_vars.leader = leader
  end

  if local_leader:lower() == '<space>' then
    vim_vars.localleader = ' '
  elseif local_leader == ' ' then
    local_leader = '<Space>'
    vim_vars.localleader = ' '
  else
    vim_vars.localleader = local_leader
  end

  --- No-op the target `<leader>` key
  local opts = { noremap = true, silent = true }
  nop(leader, opts, 'n')
  nop(leader, opts, 'v')

  --- If target `<leader>` and `<localleader>` keys aren't the same
  --- then noop `local_leader` aswell
  if leader ~= local_leader then
    nop(local_leader, opts, 'n')
    nop(local_leader, opts, 'v')
  end

  vim.g.mapleader = vim_vars.leader
  vim.g.maplocalleader = vim_vars.localleader
  vim.g.leader_set = true
end

---@param K User.Keymaps.Delete
---@param bufnr integer
---@return User.Keymaps.Delete|nil deleted_keys
---@overload fun(K: User.Keymaps.Delete): deleted_keys: User.Keymaps.Delete|nil
function Keymaps.delete(K, bufnr)
  require('user_api.check.exists').validate({
    K = { K, { 'table' } },
    bufnr = { bufnr, { 'number', 'nil' }, true },
  })
  bufnr = bufnr or nil
  if vim.tbl_isemyty(K) then
    return
  end

  local ditched_keys = {} ---@type User.Keymaps.Delete
  for k, v in pairs(K) do
    for _, key in ipairs(v) do
      vim.keymap.del(k, key, bufnr and { buffer = bufnr } or {})
    end
    ditched_keys[k] = v
  end
  return ditched_keys
end

---@type User.Config.Keymaps
---@overload fun(keys: AllModeMaps)
---@overload fun(keys: AllModeMaps, bufnr: integer)
---@overload fun(keys: AllModeMaps, bufnr: integer|nil, defaults: boolean)
local M = setmetatable({}, {
  __index = Keymaps,
  __newindex = function()
    vim.notify('User.Config.Keymaps table is Read-Only!', ERROR)
  end,
  ---@param keys AllModeMaps
  ---@param bufnr? integer
  ---@param defaults? boolean
  __call = function(_, keys, bufnr, defaults)
    require('user_api.check.exists').validate({
      keys = { keys, { 'table' } },
      bufnr = { bufnr, { 'number', 'nil' }, true },
      defaults = { defaults, { 'boolean', 'nil' }, true },
    })
    bufnr = bufnr or nil
    defaults = defaults ~= nil and defaults or false
    if vim.tbl_isempty(keys) then
      return
    end

    if not vim.g.leader_set then
      vim.notify('`keymaps.set_leader()` not called!', WARN)
    end

    local modes = require('user_api.maps').modes
    local parsed_keys = {} ---@type AllModeMaps
    for k, v in pairs(keys) do
      if not vim.list_contains(modes, k) then
        vim.notify(('Ignoring badly formatted table\n`%s`'):format(vim.inspect(keys)), WARN)
      else
        parsed_keys[k] = v
      end
    end

    Keymaps.no_oped = Keymaps.no_oped ~= nil and Keymaps.no_oped or false

    -- Noop keys after `<leader>` to avoid accidents
    for _, mode in ipairs(modes) do
      if Keymaps.no_oped then
        break
      end
      if vim.list_contains({ 'n', 'v' }, mode) then
        nop(Keymaps.NOP, { noremap = false, silent = true }, mode, '<leader>')
      end
    end

    Keymaps.no_oped = true
    Keymaps.Keys = vim.tbl_deep_extend('keep', parsed_keys, vim.deepcopy(Keymaps.Keys)) ---@type AllModeMaps

    local passed = defaults and Keymaps.Keys or parsed_keys
    require('user_api.maps').map_dict(passed, 'wk.register', true, nil, bufnr)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
