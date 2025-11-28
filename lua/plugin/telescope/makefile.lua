if not require('user_api.check.exists').module('telescope-makefile') then
    return
end

local executable = require('user_api.check.exists').executable
if not (executable('make') and executable('mingw32-make')) then
    return
end

require('telescope-makefile').setup({
    default_target = '[DEFAULT]',
    make_bin = not require('user_api.check').is_windows() and 'make' or 'mingw32-make',
})
require('telescope').load_extension('make')
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
