---@module 'lazy'
---@param arg string
---@return function
local function wincmd(arg)
  if vim.fn.has('nvim-0.11') == 1 then
    vim.validate('arg', arg, { 'string' }, false)
  else
    vim.validate({ arg = { arg, { 'string' } } })
  end
  return function()
    vim.cmd.wincmd(arg)
  end
end

local function set_terminal_keymaps(ev) ---@param ev vim.api.keyset.create_autocmd.callback_args
  if not ev then
    return
  end
  local bufnr = ev.buf
  local desc = require('user_api.maps').desc
  require('user_api.config').keymaps({
    t = {
      ['<Esc>'] = { '<C-\\><C-n>', desc('Escape Terminal', true, bufnr) },
      ['<C-e>'] = { '<C-\\><C-n>', desc('Escape Terminal', true, bufnr) },
      ['<C-w>'] = { '<C-\\><C-n><C-w>w', desc('Switch Window', true, bufnr) },
      ['<C-h>'] = { wincmd('h'), desc('Goto Left Window', true, bufnr) },
      ['<C-j>'] = { wincmd('j'), desc('Goto Down Window', true, bufnr) },
      ['<C-k>'] = { wincmd('k'), desc('Goto Up Window', true, bufnr) },
      ['<C-l>'] = { wincmd('l'), desc('Goto Right Window', true, bufnr) },
    },
  }, bufnr)
end

return { ---@type LazySpec
  'akinsho/toggleterm.nvim',
  version = false,
  enabled = not require('user_api.check').in_console(),
  config = function()
    require('toggleterm').setup({
      size = function(term) ---@param term Terminal
        return math.floor(vim.o.columns * (term.direction == 'vertical' and 0.65 or 0.85))
      end,
      open_mapping = '<A-t>',
      autochdir = true,
      hide_numbers = true,
      direction = 'float',
      close_on_exit = true,
      opts = {
        border = 'rounded',
        title_pos = 'center',
        width = math.floor(vim.o.columns * 0.85),
      },
      highlights = {
        Normal = { guibg = '#291d3f' },
        NormalFloat = { link = 'Normal' },
        FloatBorder = { guifg = '#c5c7a1', guibg = '#21443d' },
      },
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = -30,
      shading_ratio = -3,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      shell = vim.o.shell,
      auto_scroll = true,
      persist_size = true,
      persist_mode = true,
      float_opts = { border = 'curved', title_pos = 'center', zindex = 100, winblend = 3 },
      winbar = {
        enabled = true,
        name_formatter = function(term) ---@param term Terminal
          return term.name
        end,
      },
    })

    local group = vim.api.nvim_create_augroup('ToggleTerm.Hooks', { clear = true })
    require('user_api.util.autocmd').au_from_dict({
      TermOpen = { group = group, callback = set_terminal_keymaps },
    })

    local desc = require('user_api.maps').desc
    local map = { ['<A-t>'] = { ':exe v:count1 . "ToggleTerm"<CR>', desc('Toggleterm') } }
    local i_map = { ['<A-t>'] = { '<Esc>:exe v:count1 . "ToggleTerm"<CR>', desc('Toggleterm') } }
    require('user_api.config').keymaps({ n = map, i = i_map, t = map })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
