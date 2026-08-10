---@module 'lazy'

---@param arg string
---@return function cmd
local function wincmd(arg)
  require('user_api').check.validate({ arg = { arg, { 'string' } } })
  return function()
    vim.cmd.wincmd(arg)
  end
end

---@param ev vim.api.keyset.create_autocmd.callback_args
local function set_terminal_keys(ev)
  if not ev then
    return
  end
  local bufnr = ev.buf
  local desc = require('user_api').maps.desc
  require('user_api').config.keymaps.set({
    t = {
      ['<C-e>'] = { '<C-\\><C-n>', desc('Escape Terminal', { buf = bufnr }) },
      ['<C-h>'] = { wincmd('h'), desc('Goto Left Window', { buf = bufnr }) },
      ['<C-j>'] = { wincmd('j'), desc('Goto Down Window', { buf = bufnr }) },
      ['<C-k>'] = { wincmd('k'), desc('Goto Up Window', { buf = bufnr }) },
      ['<C-l>'] = { wincmd('l'), desc('Goto Right Window', { buf = bufnr }) },
      ['<C-w>'] = { '<C-\\><C-n><C-w>w', desc('Switch Window', { buf = bufnr }) },
      ['<Esc>'] = { '<C-\\><C-n>', desc('Escape Terminal', { buf = bufnr }) },
    },
  }, bufnr)
end

return { ---@type LazySpec
  'DrKJeff16/toggleterm.nvim',
  dev = true,
  version = false,
  enabled = not require('user_api').check.in_console(),
  config = function()
    require('toggleterm').setup({
      auto_scroll = true,
      autochdir = true,
      close_on_exit = true,
      direction = 'float',
      float_opts = { border = 'curved', title_pos = 'center', winblend = 3, zindex = 100 },
      hide_numbers = true,
      highlights = {
        FloatBorder = { guifg = '#c5c7a1', guibg = '#21443d' },
        Normal = { guibg = '#291d3f' },
        NormalFloat = { link = 'Normal' },
      },
      insert_mappings = true,
      open_mapping = '<A-t>',
      opts = { border = 'rounded', title_pos = 'center', width = math.floor(vim.o.columns * 0.85) },
      persist_mode = true,
      persist_size = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = -30,
      shading_ratio = -3,
      shell = vim.o.shell,
      size = function(term) ---@param term Terminal
        return math.floor(vim.o.columns * (term.direction == 'vertical' and 0.65 or 0.85))
      end,
      start_in_insert = true,
      terminal_mappings = true,
      winbar = {
        enabled = true,
        name_formatter = function(term) ---@param term Terminal
          return term.name
        end,
      },
    })

    local group = vim.api.nvim_create_augroup('ToggleTerm.Hooks', { clear = true })
    require('user_api').util.autocmd.au_from_dict({ TermOpen = { group = group, callback = set_terminal_keys } })

    local desc = require('user_api').maps.desc
    local map = { ['<A-t>'] = { ':exe v:count1 . "ToggleTerm"<CR>', desc('Toggleterm') } }
    local i_map = { ['<A-t>'] = { '<Esc>:exe v:count1 . "ToggleTerm"<CR>', desc('Toggleterm') } }
    require('user_api').config.keymaps.set({ n = map, i = i_map, t = map })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
