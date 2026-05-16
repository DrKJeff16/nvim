---@class User.Keymaps.Delete
---@field n? string[]
---@field i? string[]
---@field v? string[]
---@field t? string[]
---@field o? string[]
---@field x? string[]

local VIMRC = vim.fs.joinpath(vim.fn.stdpath('config'), 'init.lua')
local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO
local desc = require('user_api.maps').desc
local ft_get = require('user_api.util').ft_get
local optget = require('user_api.util').optget
local validate = require('user_api.check').validate

---@param force? boolean
---@return function op
local function delete_file(force)
  validate({ force = { force, { 'boolean', 'nil' }, true } })
  if force == nil then
    force = false
  end

  return function()
    local bufnr = vim.api.nvim_get_current_buf()
    local modifiable = optget('modifiable', 'buf', bufnr) --[[@as boolean]]
    local bt = optget('buftype', 'buf', bufnr) --[[@as string]]
    if not modifiable or bt == 'nowrite' then
      vim.notify('Buffer is not modifiable!', ERROR)
      return
    end

    local fname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    if vim.fn.filewritable(fname) ~= 1 then
      vim.notify(('Unable to remove `%s`!'):format(fname), ERROR)
      return
    end

    if not force then
      if vim.fn.confirm('Delete the current file?', '&Yes\n&No', 2) ~= 1 then
        return
      end
    end

    vim.system({ 'rm', '-f', fname }, { text = false }, function(obj)
      if obj.code == 0 then
        return
      end

      vim.notify(('Unable to remove `%s`!'):format(fname), ERROR)
    end)
  end
end

---@param cmd 'edit'|'ed'|'split'|'sp'|'vsplit'|'vs'|'tabnew'
---@return function|nil op
local function rcfile(cmd)
  validate({ cmd = { cmd, { 'string' } } })
  if
    not (
      vim.list_contains({ 'edit', 'ed', 'split', 'sp', 'vsplit', 'vs', 'tabnew' }, cmd)
      and vim.cmd[cmd]
      and vim.is_callable(vim.cmd[cmd])
    )
  then
    return
  end

  return function()
    vim.cmd[cmd](VIMRC)
  end
end

local function new_file()
  local ft = ft_get(vim.api.nvim_get_current_buf())
  vim.cmd.wincmd('n')
  vim.cmd.wincmd('o')

  local opts = { buf = vim.api.nvim_get_current_buf() }
  vim.api.nvim_set_option_value('ft', ft, opts)
  vim.api.nvim_set_option_value('modifiable', true, opts)
  vim.api.nvim_set_option_value('modified', false, opts)
end

local function indent_file()
  if not optget('modifiable', 'buf', vim.api.nvim_get_current_buf()) then
    vim.notify('Unable to indent. File is not modifiable!', ERROR)
    return
  end

  local win = vim.api.nvim_get_current_win()
  local saved_pos = vim.api.nvim_win_get_cursor(win)
  local reset = vim.schedule_wrap(function()
    vim.api.nvim_win_set_cursor(win, saved_pos)
  end)

  vim.api.nvim_feedkeys('gg=G', 'n', false)

  reset()
end

---@param check string
---@return function checkhealth_fun
local function gen_checkhealth(check)
  return function()
    vim.cmd.checkhealth(check)
  end
end

---@param vertical? boolean
local function gen_fun_blank(vertical)
  validate({ vertical = { vertical, { 'boolean', 'nil' }, true } })
  if vertical == nil then
    vertical = false
  end

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
  validate({ force = { force, { 'boolean', 'nil' }, true } })
  if force == nil then
    force = false
  end

  local ft_triggers = { 'NvimTree', 'noice', 'trouble' }
  local pre_exc = { ft = { 'help', 'lazy', 'man', 'noice' }, bt = { 'help' } }
  return function()
    local buf = vim.api.nvim_get_current_buf()
    local prev_ft, prev_bt = ft_get(buf), require('user_api.util').bt_get(buf)
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
---@field nop User.Config.Keymaps.NOP
---@field no_oped? boolean
local M = {}

function M.print_keys()
  vim.notify(vim.inspect(M.Keys), INFO)
end

M.Keys = { ---@type AllModeMaps
  n = {
    ['<C-w>W'] = { group = '+Move Window' },
    ['<C-w>s'] = { group = '+Split' },
    ['<leader>'] = { group = '+Open `which-key`' },
    ['<leader>F'] = { group = '+Folding' },
    ['<leader>H'] = { group = '+Help' },
    ['<leader>Hm'] = { group = '+Man Pages' },
    ['<leader>U'] = { group = '+User API' },
    ['<leader>UK'] = { group = '+Keymaps' },
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

    ['<C-w><CR>'] = { ':wincmd o<CR>', desc('Make Current Window The Only One') },
    ['<C-w><Down>'] = { ':wincmd j<CR>', desc('Go To Window Below') },
    ['<C-w><Left>'] = { ':wincmd h<CR>', desc('Go To Window On The Left') },
    ['<C-w><Right>'] = { ':wincmd l<CR>', desc('Go To Window On The Right') },
    ['<C-w><Up>'] = { ':wincmd k<CR>', desc('Go To Window Above') },
    ['<C-w>N'] = { new_file, desc('New Blank File') },
    ['<C-w>S'] = { ':wincmd x<CR>', desc('Swap Current With Next') },
    ['<C-w>W<Down>'] = { ':wincmd J<CR>', desc('Move Window To The Very Bottom') },
    ['<C-w>W<Left>'] = { ':wincmd H<CR>', desc('Move Window To Far Left') },
    ['<C-w>W<Right>'] = { ':wincmd L<CR>', desc('Move Window To Far Right') },
    ['<C-w>W<Up>'] = { ':wincmd K<CR>', desc('Move Window To The Very Top') },
    ['<C-w>n'] = { ':wincmd w<CR>', desc('Next Window') },
    ['<C-w>p'] = { ':wincmd W<CR>', desc('Previous Window') },
    ['<C-w>sV'] = { ':vsplit ', desc('Vertical Split (Prompt)', { silent = false }) },
    ['<C-w>sX'] = { ':split ', desc('Horizontal Split (Prompt)', { silent = false }) },
    ['<C-w>sv'] = { ':vsplit<CR>', desc('Vertical Split') },
    ['<C-w>sx'] = { ':split<CR>', desc('Horizontal Split') },
    ['<C-w>|'] = { ':wincmd ^<CR>', desc('Split Current To Edit Alternate File') },
    ['<Esc><Esc>'] = { ':noh<CR>', desc('Remove Highlighted Search') },
    ['<leader>/'] = { ':%s/', desc('Run Search-Replace Prompt For Whole File', { silent = false }) },
    ['<leader>Fc'] = { ':%foldclose!<CR>', desc('Close All Folds') },
    ['<leader>Fo'] = { ':%foldopen!<CR>', desc('Open All Folds') },
    ['<leader>HT'] = { ':tab help<CR>', desc('Open Help On New Tab') },
    ['<leader>HV'] = { ':vert help<CR>', desc('Open Help On Vertical Split') },
    ['<leader>HX'] = { ':hor help<CR>', desc('Open Help On Horizontal Split') },
    ['<leader>Hh'] = { ':h ', desc('Prompt For Help', { silent = false }) },
    ['<leader>HmM'] = { ':Man ', desc('Prompt For Man', { silent = false }) },
    ['<leader>HmT'] = { ':tab Man ', desc('Prompt For Man Page (Tab)', { silent = false }) },
    ['<leader>HmV'] = { ':vert Man ', desc('Prompt For Man Page (Vertical)', { silent = false }) },
    ['<leader>HmX'] = {
      ':horizontal Man ',
      desc('Prompt Man Page (Horizontal)', { silent = false }),
    },
    ['<leader>Hmm'] = { ':Man<CR>', desc('Open Manpage For Word Under Cursor') },
    ['<leader>Hmt'] = { ':tab Man<CR>', desc('Open Man Page (Tab)') },
    ['<leader>Hmv'] = { ':vert Man<CR>', desc('Open Man Page (Vertical)') },
    ['<leader>Hmx'] = { ':horizontal Man<CR>', desc('Open Man Page (Horizontal)') },
    ['<leader>Ht'] = { ':tab h ', desc('Prompt For Help On New Tab', { silent = false }) },
    ['<leader>Hv'] = {
      ':vertical h ',
      desc('Prompt For Help On Vertical Split', { silent = false }),
    },
    ['<leader>Hx'] = {
      ':horizontal h ',
      desc('Prompt For Help On Horizontal Split', { silent = false }),
    },
    ['<leader>UKp'] = { M.print_keys, desc('Print all custom keymaps') },
    ['<leader>bD'] = { buf_del(true), desc('Close Buffer Forcefully') },
    ['<leader>bd'] = { buf_del(), desc('Close Buffer') },
    ['<leader>bf'] = { vim.cmd.bfirst, desc('Goto First Buffer') },
    ['<leader>bl'] = { vim.cmd.blast, desc('Goto Last Buffer') },
    ['<leader>bn'] = { vim.cmd.bnext, desc('Next Buffer') },
    ['<leader>bp'] = { vim.cmd.bprevious, desc('Previous Buffer') },
    ['<leader>fD'] = { delete_file(true), desc('Delete Current File (Forcefully)') },
    ['<leader>fFv'] = { gen_fun_blank(true), desc('New Vertical Blank File') },
    ['<leader>fFx'] = { gen_fun_blank(), desc('New Horizontal Blank File') },
    ['<leader>fS'] = { ':w ', desc('Prompt Save File', { silent = false }) },
    ['<leader>fd'] = { delete_file(), desc('Delete Current File') },
    ['<leader>fiR'] = { ':%retab!<CR>', desc('Retab File (Forcefully)') },
    ['<leader>fii'] = { indent_file, desc('Indent Whole File') },
    ['<leader>fir'] = { ':%retab<CR>', desc('Retab File') },
    ['<leader>fs'] = { ':w ++p<CR>', desc('Save File') },
    ['<leader>fvL'] = { ':luafile ', desc('Source Lua File (Prompt)', { silent = false }) },
    ['<leader>fvV'] = { ':source ', desc('Source VimScript File (Prompt)', { silent = false }) },
    ['<leader>fvl'] = { ':luafile %<CR>', desc('Source Current File As Lua File') },
    ['<leader>fvv'] = { ':source %<CR>', desc('Source Current File') },
    ['<leader>qQ'] = { ':quitall!<CR>', desc('Quit Nvim Forcefully') },
    ['<leader>qq'] = { vim.cmd.quitall, desc('Quit Nvim') },
    ['<leader>qr'] = { ':restart +qall!<CR>', desc('Restart Nvim') },
    ['<leader>tA'] = { vim.cmd.tabnew, desc('New Tab') },
    ['<leader>tD'] = { ':tabclose!<CR>', desc('Close Tab Forcefully') },
    ['<leader>ta'] = { ':tabnew ', desc('New Tab (Prompt)', { silent = false }) },
    ['<leader>td'] = { vim.cmd.tabclose, desc('Close Tab') },
    ['<leader>tf'] = { vim.cmd.tabfirst, desc('Goto First Tab') },
    ['<leader>tl'] = { vim.cmd.tablast, desc('Goto Last Tab') },
    ['<leader>tn'] = { vim.cmd.tabnext, desc('Next Tab') },
    ['<leader>tp'] = { vim.cmd.tabprevious, desc('Previous Tab') },
    ['<leader>vM'] = { vim.cmd.messages, desc('Run `:messages`') },
    ['<leader>vN'] = { vim.cmd.Notifications, desc('Run `:Notifications`') },
    ['<leader>vee'] = { rcfile('edit'), desc('Open In Current Window') },
    ['<leader>vet'] = { rcfile('tabnew'), desc('Open In New Tab') },
    ['<leader>vev'] = { rcfile('vsplit'), desc('Open In Vertical Split') },
    ['<leader>vex'] = { rcfile('split'), desc('Open In Horizontal Split') },
    ['<leader>vhD'] = { gen_checkhealth('vim.deprecated'), desc('`vim.deprecated`') },
    ['<leader>vhH'] = { ':checkhealth ', desc('Prompt', { silent = false }) },
    ['<leader>vhd'] = { gen_checkhealth('vim.health'), desc('`vim.health`') },
    ['<leader>vhh'] = { vim.cmd.checkhealth, desc('Run') },
    ['<leader>vhl'] = { gen_checkhealth('vim.lsp'), desc('`vim.lsp`') },
    ['<leader>vhp'] = { gen_checkhealth('vim.provider'), desc('`vim.provider`') },
    ['<leader>vht'] = { gen_checkhealth('vim.treesitter'), desc('`vim.treesitter`') },
    ['<leader>vs'] = { ':source $MYVIMRC<CR>', desc('Source $MYVIMRC') },
  },
  v = {
    ['<C-w>W'] = { group = '+Move Window' },
    ['<C-w>s'] = { group = '+Split' },
    ['<leader>'] = { group = '+Open `which-key`' },
    ['<leader>f'] = { group = '+File' },
    ['<leader>fF'] = { group = '+Folding' },
    ['<leader>fi'] = { group = '+Indent' },
    ['<leader>h'] = { group = '+Help' },
    ['<leader>q'] = { group = '+Quit Nvim' },
    ['<leader>v'] = { group = '+Vim' },
    ['<leader>w'] = { proxy = '<C-w>', group = 'Window' },

    ['<C-w><CR>'] = { ':wincmd o<CR>', desc('Make Current Window The Only One') },
    ['<C-w><Down>'] = { ':wincmd j<CR>', desc('Go To Window Below') },
    ['<C-w><Left>'] = { ':wincmd h<CR>', desc('Go To Window On The Left') },
    ['<C-w><Right>'] = { ':wincmd l<CR>', desc('Go To Window On The Right') },
    ['<C-w><Up>'] = { ':wincmd k<CR>', desc('Go To Window Above') },
    ['<C-w>N'] = { new_file, desc('New Blank File') },
    ['<C-w>S'] = { ':wincmd x<CR>', desc('Swap Current With Next') },
    ['<C-w>W<Down>'] = { ':wincmd J<CR>', desc('Move Window To The Very Bottom') },
    ['<C-w>W<Left>'] = { ':wincmd H<CR>', desc('Move Window To Far Left') },
    ['<C-w>W<Right>'] = { ':wincmd L<CR>', desc('Move Window To Far Right') },
    ['<C-w>W<Up>'] = { ':wincmd K<CR>', desc('Move Window To The Very Top') },
    ['<C-w>n'] = { ':wincmd w<CR>', desc('Next Window') },
    ['<C-w>p'] = { ':wincmd W<CR>', desc('Previous Window') },
    ['<C-w>sV'] = { ':vsplit ', desc('Vertical Split (Prompt)', { silent = false }) },
    ['<C-w>sX'] = { ':split ', desc('Horizontal Split (Prompt)', { silent = false }) },
    ['<C-w>sv'] = { ':vsplit<CR>', desc('Vertical Split') },
    ['<C-w>sx'] = { ':split<CR>', desc('Horizontal Split') },
    ['<C-w>|'] = { ':wincmd ^<CR>', desc('Split Current To Edit Alternate File') },
    ['<leader>S'] = { ':sort!<CR>', desc('Sort Selection (Reverse)') },
    ['<leader>fFc'] = { ':foldclose<CR>', desc('Close Fold') },
    ['<leader>fFo'] = { ':foldopen<CR>', desc('Open Fold') },
    ['<leader>fiR'] = { ':retab!<CR>', desc('Retab Selection Forcefully') },
    ['<leader>fir'] = { ':retab<CR>', desc('Retab Selection') },
    ['<leader>fr'] = { ':s/', desc('Search/Replace Prompt For Selection', { silent = false }) },
    ['<leader>qQ'] = { ':qa!<CR>', desc('Quit Nvim Forcefully') },
    ['<leader>qq'] = { ':qa<CR>', desc('Quit Nvim') },
    ['<leader>s'] = { ':sort<CR>', desc('Sort Selection') },
  },
  t = { ['<Esc>'] = { '<C-\\><C-n>', desc('Escape Terminal') } },
}

---Set both the `<leader>` and `<localleader>` keys.
--- ---
---@param leader string `<leader>` key string (defaults to `<Space>`)
---@param local_leader? string `<localleader>` string (defaults to `<Space>`)
---@param force? boolean Force leader switch (defaults to `false`)
function M.set_leader(leader, local_leader, force)
  validate({
    leader = { leader, { 'string' } },
    local_leader = { local_leader, { 'string', 'nil' }, true },
    force = { force, { 'boolean', 'nil' }, true },
  })
  leader = leader ~= '' and leader or '<Space>'
  local_leader = (local_leader and local_leader ~= '') and local_leader or leader
  if force == nil then
    force = false
  end
  if vim.g.leader_set and not force then
    return
  end

  local nop = require('user_api.maps').nop
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
function M.delete(K, bufnr)
  validate({
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

---@param keys AllModeMaps
---@param bufnr? integer
---@param defaults? boolean
function M.set(keys, bufnr, defaults)
  validate({
    keys = { keys, { 'table' } },
    bufnr = { bufnr, { 'number', 'nil' }, true },
    defaults = { defaults, { 'boolean', 'nil' }, true },
  })
  bufnr = bufnr or nil
  if defaults == nil then
    defaults = false
  end
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

  if M.no_oped == nil then
    M.no_oped = false
  end

  -- Noop keys after `<leader>` to avoid accidents
  for _, mode in ipairs(modes) do
    if M.no_oped then
      break
    end
    if vim.list_contains({ 'n', 'v' }, mode) then
      require('user_api.maps').nop(require('user_api.config.keymaps.nop'), { noremap = false }, mode, '<leader>')
    end
  end

  M.no_oped = true
  M.Keys = vim.tbl_deep_extend('keep', parsed_keys, M.Keys) ---@type AllModeMaps

  local passed = defaults and M.Keys or parsed_keys
  require('user_api.maps').map_dict(passed, 'wk.register', true, nil, bufnr)
end

return setmetatable(M, { ---@type User.Config.Keymaps
  __index = function(self, k)
    if require('user_api.check').module('user_api.config.keymaps.' .. k) then
      return require('user_api.config.keymaps.' .. k)
    end

    return rawget(self, k) or nil
  end,
})
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
