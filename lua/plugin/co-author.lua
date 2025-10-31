---@module 'lazy'

---@type LazySpec
return {
    '2kabhishek/co-author.nvim',
    version = false,
    ft = { 'gitcommit', 'gitrebase' },
    dependencies = { 'folke/snacks.nvim' },
    config = function()
        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = { ['<leader>Ga'] = { vim.cmd.CoAuthor, desc('Run `:CoAuthor`') } },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
