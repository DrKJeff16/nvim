---@module 'lazy'

return { ---@type LazySpec
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  version = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local nt = require('nvim-tree')
    nt.setup({
      on_attach = function(bufnr)
        local ok, api = pcall(require, 'nvim-tree.api')
        assert(ok, 'api module is not found')

        api.map.on_attach.default(bufnr)

        local desc = require('user_api').maps.desc
        require('user_api').config.keymaps.set({
          n = {
            ['<CR>'] = {
              function()
                local nt_api = require('nvim-tree.api')
                nt_api.node.open.edit()

                if nt_api.tree.is_visible() and nt_api.tree.get_node_under_cursor().type == 'file' then
                  nt_api.tree.close()
                end
              end,
              desc('', { buf = bufnr }),
            },
          },
        }, bufnr)
      end,
      hijack_directories = { enable = true },
      reload_on_bufenter = true,
      sync_root_with_cwd = true,
      sort = { sorter = 'case_sensitive' },
      respect_buf_cwd = true,
      view = { preserve_window_proportions = true, centralize_selection = false },
      renderer = {
        group_empty = false,
        add_trailing = true,
        decorators = { 'Copied', 'Cut', 'Diagnostics', 'Git', 'Modified', 'Open' },
      },
      filesystem_watchers = { enable = true },
      modified = { enable = true, show_on_dirs = true, show_on_open_dirs = false },
      auto_reload_on_write = true,
      disable_netrw = true,
      hijack_cursor = true,
      hijack_netrw = true,
      filters = { dotfiles = false, git_ignored = false, custom = { '^.git$' } },
      update_focused_file = { enable = true, update_root = { enable = true } },
    })

    local api = require('nvim-tree.api')
    api.events.subscribe(api.events.Event.FileCreated, function(file)
      vim.cmd.edit(vim.fn.fnameescape(file.fname))
    end)
    api.events.subscribe(api.events.Event.TreeOpen, function()
      local tree_winid = api.tree.winid()
      if tree_winid ~= nil then
        vim.api.nvim_set_option_value('statusline', '%t', { win = tree_winid })
      end
    end)

    vim.api.nvim_create_autocmd('QuitPre', {
      callback = function()
        local tree_wins, floating_wins = {}, {} ---@type integer[], integer[]
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
          if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w)):match('NvimTree_') then
            table.insert(tree_wins, w)
          elseif vim.api.nvim_win_get_config(w).relative ~= '' then
            table.insert(floating_wins, w)
          end
        end
        if #wins - #floating_wins - #tree_wins ~= 1 then
          return
        end
        for _, w in ipairs(tree_wins) do
          vim.api.nvim_win_close(w, true)
        end
      end,
    })

    -- Make :bd and :q behave as usual when tree is visible
    vim.api.nvim_create_autocmd({ 'BufEnter', 'QuitPre' }, {
      nested = false,
      callback = function(e)
        local tree = require('nvim-tree.api').tree
        if not tree.is_visible() then
          return
        end

        local winCount = 0
        for _, winId in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(winId).focusable then
            winCount = winCount + 1
          end
        end

        if e.event == 'QuitPre' and winCount == 2 then
          vim.api.nvim_cmd({ cmd = 'qall' }, {})
        end
        if e.event == 'BufEnter' and winCount == 1 then
          vim.defer_fn(function()
            tree.toggle({ find_file = true, focus = true })
            tree.toggle({ find_file = true, focus = false })
          end, 10)
        end
      end,
    })

    require('user_api').highlight.hl_from_dict({
      NvimTreeExecFile = { fg = '#ffa0a0' },
      NvimTreeSpecialFile = { fg = '#ff80ff', underline = true },
      NvimTreeSymlink = { fg = 'Yellow' },
      NvimTreeImageFile = { link = 'Title' },
    })

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = {
        ['<leader>ft'] = { group = '+File Tree' },
        ['<leader>ftt'] = { vim.cmd.NvimTreeToggle, desc('Toggle') },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
