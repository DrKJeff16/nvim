---@module 'lazy'

return { ---@type LazySpec
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
            achievements = {
                {
                    id = 'first_500',
                    name = 'Newbie',
                    desc = 'Type 500 Characters',
                    icon = '✨',
                    check = function(stats)
                        return stats.chars_typed >= 500
                    end,
                },
            },
            ignore_ft = { 'yaml', 'markdown', 'toml', 'dosini', 'conf', 'config', 'hyprlang' },
            custom_languages = {
                gleam = { icon = '✨', name = 'Gleam' },
                odin = { icon = '🔷', name = 'Odin' },
            },
            level_progression = {
                tier_1 = { min_level = 1, max_level = 15, xp_per_level = 600 },
                tier_2 = { min_level = 16, max_level = 30, xp_per_level = 1200 },
                tier_3 = { min_level = 31, max_level = math.huge, xp_per_level = 3000 },
            },
            xp_rewards = { char = 1, line = 2, save = 20 },
        })

        require('user_api.config').keymaps({ n = { ['<leader>T'] = { group = '+Triforce' } } })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
