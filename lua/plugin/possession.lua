---@module 'lazy'

---@type LazySpec
return {
    'gennaro-tedesco/nvim-possession',
    version = false,
    dependencies = { 'ibhagwan/fzf-lua' },
    config = function()
        local desc = require('user_api.maps').desc
        require('nvim-possession').setup({
            sessions = { sessions_prompt = 'Possession Prompt: ' },
            autoload = true,
            autosave = true,
            autoprompt = true,
            autoswitch = { enable = true, exclude_ft = { 'text', 'markdown' } },
            save_hook = function()
                if require('user_api.check.exists').module('scope') then
                    vim.cmd.ScopeSaveState()
                end
                local visible_buffers = {}
                for _, win in next, vim.api.nvim_list_wins() do
                    visible_buffers[vim.api.nvim_win_get_buf(win)] = true
                end
                for _, bufnr in next, vim.api.nvim_list_bufs() do
                    if visible_buffers[bufnr] == nil then
                        pcall(vim.cmd.bdel, bufnr)
                    end
                end
            end,
            post_hook = function()
                if require('user_api.check.exists').module('scope') then
                    vim.cmd.ScopeLoadState()
                end
                vim.lsp.buf.format()
                require('nvim-tree.api').tree.toggle()
            end,
            fzf_hls = {
                normal = 'Normal',
                preview_normal = 'Normal',
                border = 'Todo',
                preview_border = 'Constant',
            },
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
