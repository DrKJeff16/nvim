---@module 'lazy'

---@class GitSignOpts
---@field text string

---@alias GitSigns table<'add'|'change'|'delete'|'topdelete'|'changedelete'|'untracked', GitSignOpts>
---@alias GitSignsArr GitSigns[]

return { ---@type LazySpec
  'lewis6991/gitsigns.nvim',
  version = false,
  cond = require('user_api.check.exists').executable('git'),
  config = function()
    local GS = require('gitsigns')
    GS.setup({
      on_attach = function(bufnr) ---@param bufnr? integer
        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps.set({
          n = {
            ['<leader>G'] = { group = '+Git' },
            ['<leader>Gh'] = { group = '+GitSigns Hunks' },
            ['<leader>Gt'] = { group = '+GitSigns Toggles' },
            ['<leader>Gh]'] = {
              function()
                if vim.wo.diff then
                  vim.cmd.normal({ ']c', bang = true })
                else
                  GS.nav_hunk('next') ---@diagnostic disable-line
                end
              end,
              desc('Next Hunk'),
            },
            ['<leader>Gh['] = {
              function()
                if vim.wo.diff then
                  vim.cmd.normal({ '[c', bang = true })
                else
                  GS.nav_hunk('prev') ---@diagnostic disable-line
                end
              end,
              desc('Previous Hunk'),
            },
            ['<leader>Ghs'] = { GS.stage_hunk, desc('Stage Current Hunk') },
            ['<leader>Ghr'] = { GS.reset_hunk, desc('Reset Current Hunk') },
            ['<leader>Ghu'] = { GS.stage_hunk, desc('Undo Hunk Stage') },
            ['<leader>Ghp'] = { GS.preview_hunk, desc('Preview Current Hunk') },
            ['<leader>GhS'] = { GS.stage_buffer, desc('Stage The Whole Buffer') },
            ['<leader>GhR'] = { GS.reset_buffer, desc('Reset The Whole Buffer') },
            ['<leader>Ghb'] = {
              function()
                GS.blame_line({ full = true })
              end,
              desc('Blame Current Line'),
            },
            ['<leader>Ghd'] = { GS.diffthis, desc('Diff Against Index') },
            ['<leader>Gtb'] = {
              GS.toggle_current_line_blame,
              desc('Toggle Line Blame'),
            },
            ['<leader>Gtd'] = { GS.preview_hunk_inline, desc('Toggle Deleted') },
          },
          v = {
            ['<leader>G'] = { group = '+Git' },
            ['<leader>Gh'] = { group = '+GitSigns Hunks' },
            ['<leader>Ghs'] = {
              function()
                GS.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
              end,
              desc('Stage Selected Hunks'),
            },
            ['<leader>Ghr'] = {
              function()
                GS.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
              end,
              desc('Reset Selected Hunks'),
            },
          },
          o = { ['ih'] = { ':<C-U>Gitsigns select_hunk<CR>' } },
          x = { ['ih'] = { ':<C-U>Gitsigns select_hunk<CR>' } },
        }, bufnr)
      end,
      signs = { ---@type GitSigns
        add = { text = '+' },
        change = { text = '┃' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = { ---@type GitSigns
        add = { text = '+' },
        change = { text = '┃' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = vim.o.signcolumn == 'yes',
      numhl = vim.o.number,
      linehl = false,
      word_diff = false,
      watch_gitdir = { follow_files = true },
      auto_attach = true,
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = false,
        virt_text_pos = 'overlay', ---@type 'eol'|'overlay'|'right_align'
        delay = 1250,
        ignore_whitespace = false,
        virt_text_priority = 3,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 4,
      update_debounce = 100,
      max_file_length = 40000,
      status_formatter = nil,
      preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
