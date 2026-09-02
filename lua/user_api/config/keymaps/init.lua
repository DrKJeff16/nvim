---@class User.Keymaps.Delete
---@field V? string[]
---@field i? string[]
---@field n? string[]
---@field o? string[]
---@field t? string[]
---@field v? string[]
---@field x? string[]

local ERROR = vim.log.levels.ERROR
local desc = require('user_api.maps').desc
local validate = require('user_api.check').validate

local leader_set = false
local defaults_mapped = false

---@param cmd string
---@return function command
local function wincmd(cmd)
  return function()
    pcall(vim.cmd.wincmd, cmd)
  end
end

---@param force? boolean
---@return function op
local function delete_file(force)
  validate({ force = { force, { 'boolean', 'nil' }, true } })
  if force == nil then
    force = false
  end

  return function()
    local optget = require('user_api.util').optget
    local bufnr = vim.api.nvim_get_current_buf()
    if
      not optget('modifiable', 'buf', bufnr)
      or vim.list_contains({ 'nowrite', 'nofile' }, optget('buftype', 'buf', bufnr))
    then
      vim.notify('Buffer is not modifiable!', ERROR)
      return
    end

    local fname = vim.api.nvim_buf_get_name(bufnr)
    if vim.fn.filewritable(fname) ~= 1 then
      vim.notify(('Unable to remove `%s`!'):format(fname), ERROR)
      return
    end

    if force or vim.fn.confirm('Delete the current file?', '&Yes\n&No', 2) == 1 then
      vim.system({ 'rm', '-f', fname }, { text = false }, function(obj)
        if obj.code ~= 0 then
          vim.notify(('Unable to remove `%s`!'):format(fname), ERROR)
        end
      end)
    end
  end
end

---@param cmd 'edit'|'ed'|'split'|'sp'|'vsplit'|'vs'|'tabnew'
---@return function|nil|? op
local function rcfile(cmd)
  validate({ cmd = { cmd, { 'string' } } })

  if vim.cmd[cmd] then
    return function()
      vim.cmd[cmd]({ args = { vim.fs.joinpath(vim.fn.stdpath('config'), 'init.lua') } })
    end
  end
end

local function new_file()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = require('user_api.util').ft_get(bufnr)
  local optset = require('user_api.util').optset
  vim.cmd.wincmd('n')
  vim.cmd.wincmd('o')

  optset('ft', ft, 'buf', bufnr)
  optset('modifiable', true, 'buf', bufnr)
  optset('modified', false, 'buf', bufnr)
end

local function indent_file()
  local optget = require('user_api.util').optget
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
  validate({ check = { check, { 'string' } } })

  return function()
    vim.cmd.checkhealth({ args = vim.split(check, ' ', { trimempty = true }) })
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

    local optset = require('user_api.util').optset
    optset('filetype', '', 'buf', buf)
    optset('buftype', '', 'buf', buf)
    optset('modifiable', true, 'buf', buf)
    optset('modified', false, 'buf', buf)
  end
end

---@param force? boolean
local function buf_del(force)
  validate({ force = { force, { 'boolean', 'nil' }, true } })
  if force == nil then
    force = false
  end

  return function()
    local ft_triggers = { 'NvimTree', 'noice', 'trouble' }
    local pre_exc = { ft = { 'help', 'lazy', 'man', 'noice' }, bt = { 'help' } }
    local buf = vim.api.nvim_get_current_buf()
    local prev_ft, prev_bt = require('user_api.util').ft_get(buf), require('user_api.util').bt_get(buf)
    if not force then
      force = prev_bt == 'terminal'
    end

    vim.cmd.bdelete({ bang = force })
    if vim.list_contains(pre_exc.ft, prev_ft) or vim.list_contains(pre_exc.bt, prev_bt) then
      return
    end

    if vim.list_contains(ft_triggers, require('user_api.util').ft_get(buf)) then
      vim.cmd.bprevious()
    end
  end
end

local no_oped ---@type boolean

---@class User.Config.Keymaps
local M = {}

local keys = { ---@type AllModeMaps
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

    ['<C-w><CR>'] = { wincmd('o'), desc('Make Current Window The Only One') },
    ['<C-w><Down>'] = { wincmd('j'), desc('Go To Window Below') },
    ['<C-w><Left>'] = { wincmd('h'), desc('Go To Window On The Left') },
    ['<C-w><Right>'] = { wincmd('l'), desc('Go To Window On The Right') },
    ['<C-w><Up>'] = { wincmd('k'), desc('Go To Window Above') },
    ['<C-w>N'] = { new_file, desc('New Blank File') },
    ['<C-w>S'] = { wincmd('x'), desc('Swap Current With Next') },
    ['<C-w>W<Down>'] = { wincmd('J'), desc('Move Window To The Very Bottom') },
    ['<C-w>W<Left>'] = { wincmd('H'), desc('Move Window To Far Left') },
    ['<C-w>W<Right>'] = { wincmd('L'), desc('Move Window To Far Right') },
    ['<C-w>W<Up>'] = { wincmd('K'), desc('Move Window To The Very Top') },
    ['<C-w>d'] = { wincmd('q'), desc('Close Window') },
    ['<C-w>n'] = { wincmd('w'), desc('Next Window') },
    ['<C-w>p'] = { wincmd('W'), desc('Previous Window') },
    ['<C-w>sV'] = { ':vsplit ', desc('Vertical Split (Prompt)', { silent = false }) },
    ['<C-w>sX'] = { ':split ', desc('Horizontal Split (Prompt)', { silent = false }) },
    ['<C-w>sv'] = { vim.cmd.vsplit, desc('Vertical Split') },
    ['<C-w>sx'] = { vim.cmd.split, desc('Horizontal Split') },
    ['<C-w>|'] = { wincmd('^'), desc('Split Current To Edit Alternate File') },
    ['<Esc><Esc>'] = { vim.cmd.noh, desc('Remove Highlighted Search') },
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
    ['<leader>HmX'] = { ':hor Man ', desc('Prompt Man Page (Horizontal)', { silent = false }) },
    ['<leader>Hmm'] = { ':Man<CR>', desc('Open Manpage For Word Under Cursor') },
    ['<leader>Hmt'] = { ':tab Man<CR>', desc('Open Man Page (Tab)') },
    ['<leader>Hmv'] = { ':vert Man<CR>', desc('Open Man Page (Vertical)') },
    ['<leader>Hmx'] = { ':hor Man<CR>', desc('Open Man Page (Horizontal)') },
    ['<leader>Ht'] = { ':tab h ', desc('Prompt For Help On New Tab', { silent = false }) },
    ['<leader>Hv'] = { ':vert h ', desc('Prompt For Help On Vertical Split', { silent = false }) },
    ['<leader>Hx'] = { ':hor h ', desc('Prompt For Help On Horizontal Split', { silent = false }) },
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
    ['<leader>qr'] = { vim.cmd.restart, desc('Restart Nvim') },
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

    ['<C-w><CR>'] = { wincmd('o'), desc('Make Current Window The Only One') },
    ['<C-w><Down>'] = { wincmd('j'), desc('Go To Window Below') },
    ['<C-w><Left>'] = { wincmd('h'), desc('Go To Window On The Left') },
    ['<C-w><Right>'] = { wincmd('l'), desc('Go To Window On The Right') },
    ['<C-w><Up>'] = { wincmd('k'), desc('Go To Window Above') },
    ['<C-w>N'] = { new_file, desc('New Blank File') },
    ['<C-w>S'] = { wincmd('x'), desc('Swap Current With Next') },
    ['<C-w>W<Down>'] = { wincmd('J'), desc('Move Window To The Very Bottom') },
    ['<C-w>W<Left>'] = { wincmd('H'), desc('Move Window To Far Left') },
    ['<C-w>W<Right>'] = { wincmd('L'), desc('Move Window To Far Right') },
    ['<C-w>W<Up>'] = { wincmd('K'), desc('Move Window To The Very Top') },
    ['<C-w>d'] = { wincmd('q'), desc('Close Window') },
    ['<C-w>n'] = { wincmd('w'), desc('Next Window') },
    ['<C-w>p'] = { wincmd('W'), desc('Previous Window') },
    ['<C-w>sV'] = { ':vsplit ', desc('Vertical Split (Prompt)', { silent = false }) },
    ['<C-w>sX'] = { ':split ', desc('Horizontal Split (Prompt)', { silent = false }) },
    ['<C-w>sv'] = { vim.cmd.vsplit, desc('Vertical Split') },
    ['<C-w>sx'] = { vim.cmd.split, desc('Horizontal Split') },
    ['<C-w>|'] = { wincmd('^'), desc('Split Current To Edit Alternate File') },
    ['<leader>/'] = { ':s/', desc('Run Search-Replace Prompt For Selection', { silent = false }) },
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

function M.print_keys()
  vim.notify(vim.inspect(keys), vim.log.levels.INFO)
end

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
  if leader_set and not force then
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
  leader_set = true
end

---@param K User.Keymaps.Delete
---@param bufnr? integer
---@return User.Keymaps.Delete|nil|? deleted_keys
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

---@param new_keys AllModeMaps
---@param bufnr? integer
---@param defaults? boolean
function M.set(new_keys, bufnr, defaults)
  validate({
    new_keys = { new_keys, { 'table' } },
    bufnr = { bufnr, { 'number', 'nil' }, true },
    defaults = { defaults, { 'boolean', 'nil' }, true },
  })
  if vim.tbl_isempty(new_keys) then
    return
  end
  bufnr = bufnr or nil
  if defaults == nil then
    defaults = false
  end
  if not leader_set then
    vim.notify('`keymaps.set_leader()` not called!', vim.log.levels.WARN)
  end

  local modes = require('user_api.maps').modes
  local parsed_keys = {} ---@type AllModeMaps
  for k, v in pairs(new_keys) do
    if not vim.list_contains(modes, k) then
      vim.notify(('Ignoring badly formatted table\n`%s`'):format(vim.inspect(new_keys)), vim.log.levels.WARN)
    else
      parsed_keys[k] = v
    end
  end

  if no_oped == nil then
    no_oped = false
  end

  -- Noop keys after `<leader>` to avoid accidents
  for _, mode in ipairs(modes) do
    if no_oped then
      break
    end
    if vim.list_contains({ 'n', 'v' }, mode) then
      require('user_api.maps').nop(require('user_api.config.keymaps.nop'), { noremap = false }, mode, '<leader>')
    end
  end

  no_oped = true
  keys = vim.tbl_deep_extend('keep', parsed_keys, keys) --[[@as AllModeMaps]]

  local keymaps = vim.deepcopy(parsed_keys)
  if defaults and not defaults_mapped then
    keymaps = vim.deepcopy(keys)
    defaults_mapped = true
  end
  require('user_api.maps').map_dict(keymaps, 'wk.register', true, nil, bufnr)
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
