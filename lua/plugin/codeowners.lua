---@module 'lazy'

return { ---@type LazySpec
    'rhysd/vim-syntax-codeowners',
    lazy = false,
    version = false,
    init = require('config.util').flag_installed('codeowners'),
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
