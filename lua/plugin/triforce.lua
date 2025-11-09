---@module 'lazy'

---@type LazySpec
return {
    'gisketch/triforce.nvim',
    dev = true,
    version = false,
    dependencies = { 'nvzone/volt' },
    config = function()
        require('triforce').setup({
            enabled = true,
            gamification_enabled = true,
            notifications = { enabled = true, level_up = true, achievements = true },
            keymap = { show_profile = '<leader>Tp' },
            auto_save_interval = 300,
            custom_languages = {
                bash = { icon = '', name = 'Bash' },
                c = { icon = '', name = 'C' },
                lua = { icon = '', name = 'Lua' },
            },
            level_progression = {
                tier_1 = { min_level = 1, max_level = 15, xp_per_level = 600 },
                tier_2 = { min_level = 16, max_level = 30, xp_per_level = 1200 },
                tier_3 = { min_level = 31, max_level = math.huge, xp_per_level = 3000 },
            },
            xp_rewards = { char = 1, line = 2, save = 20 },
            require('user_api.config').keymaps({ n = { ['<leader>Tp'] = { group = '+Triforce' } } }),
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
