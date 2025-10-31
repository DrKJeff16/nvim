---@module 'lazy'

---@type LazySpec
return {
    'gennaro-tedesco/nvim-possession',
    version = false,
    dependencies = { 'ibhagwan/fzf-lua' },
    config = function()
        local desc = require('user_api.maps').desc
        require('nvim-possession').setup({
            sessions = {
                -- sessions_path = ... -- folder to look for sessions, must be a valid existing path
                -- sessions_variable = ... -- defines vim.g[sessions_variable] when a session is loaded
                -- sessions_icon = ...-- string: shows icon both in the prompt and in the statusline
                sessions_prompt = 'Possession Prompt: ', -- fzf prompt string
            },
            autoload = true, -- whether to autoload sessions in the cwd at startup
            autosave = true, -- whether to autosave loaded sessions before quitting
            autoprompt = true,
            autoswitch = { enable = true, exclude_ft = { 'text', 'markdown' } },
            save_hook = function()
                if require('user_api.check.exists').module('scope') then
                    vim.cmd.ScopeSaveState() -- scope.nvim saving
                end
                local visible_buffers = {}
                for _, win in next, vim.api.nvim_list_wins() do
                    visible_buffers[vim.api.nvim_win_get_buf(win)] = true
                end
                for _, bufnr in next, vim.api.nvim_list_bufs() do
                    if visible_buffers[bufnr] == nil then -- Delete buffer if not visible
                        pcall(vim.cmd.bdel, bufnr)
                    end
                end
            end,
            post_hook = function()
                if require('user_api.check.exists').module('scope') then
                    vim.cmd.ScopeLoadState() -- scope.nvim saving
                end
                vim.lsp.buf.format()
                require('nvim-tree.api').tree.toggle()
            end,
            fzf_hls = { ---@type possession.Hls
                normal = 'Normal',
                preview_normal = 'Normal',
                border = 'Todo',
                preview_border = 'Constant',
            },
            ---@type possession.Winopts
            fzf_winopts = { width = 0.5, preview = { vertical = 'right:30%' } },
            sort = require('nvim-possession.sorting').time_sort,
        })
        require('user_api.config').keymaps({
            n = {
                ['<leader>s'] = { group = '+Session' },
                ['<leader>sl'] = { require('nvim-possession').list, desc('📌 List Sessions') },
                ['<leader>sn'] = { require('nvim-possession').new, desc('📌 Create New Session') },
                ['<leader>su'] = {
                    require('nvim-possession').update,
                    desc('📌 Update Current Session'),
                },
                ['<leader>sd'] = {
                    require('nvim-possession').delete,
                    desc('📌 Delete Selected Session'),
                },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
