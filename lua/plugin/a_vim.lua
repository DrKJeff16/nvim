---@module 'lazy'

return { ---@type LazySpec
  'vim-scripts/a.vim',
  lazy = true,
  ft = { 'c', 'cpp' },
  version = false,
  init = require('config.util').flag_installed('a_vim'),
  config = function()
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('User.A_Vim', { clear = true }),
      pattern = {
        '*.c',
        '*.cc',
        '*.cpp',
        '*.cxx',
        '*.c++',
        '*.C',
        '*.h',
        '*.hh',
        '*.hpp',
        '*.hxx',
        '*.h++',
        '*.H',
      },
      callback = function(ev)
        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
          i = { ['<C-Tab>'] = { '<Esc>:IH<CR>', buffer = ev.buf } },
          n = {
            ['<leader><C-h>'] = { group = '+Header/Source Switch', buffer = ev.buf },
            ['<leader><C-h>s'] = { ':A<CR>', desc('Cycle Header/Source', true, ev.buf) },
            ['<leader><C-h>x'] = { ':AS<CR>', desc('Horizontal Cycle', true, ev.buf) },
            ['<leader><C-h>v'] = { ':AV<CR>', desc('Vertical Cycle', true, ev.buf) },
            ['<leader><C-h>t'] = { ':AT<CR>', desc('Tab Cycle', true, ev.buf) },
            ['<leader><C-h>S'] = { ':IH<CR>', desc('Cycle (Cursor)', true, ev.buf) },
            ['<leader><C-h>X'] = {
              ':IHS<CR>',
              desc('Horizontal Cycle (Cursor)', true, ev.buf),
            },
            ['<leader><C-h>V'] = {
              ':IHV<CR>',
              desc('Vertical Cycle (Cursor)', true, ev.buf),
            },
            ['<leader><C-h>T'] = {
              ':IHT<CR>',
              desc('Tab Cycle (Cursor)', true, ev.buf),
            },
          },
        }, ev.buf)
      end,
    })

    vim.keymap.del({ 'n', 'i' }, '<leader>ihn')
    vim.keymap.del({ 'n', 'i' }, '<leader>ih')
    vim.keymap.del({ 'n', 'i' }, '<leader>is')
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
