---@module 'lazy'

---@type LazySpec
return {
    'hat0uma/doxygen-previewer.nvim',
    cmd = { 'DoxygenOpen', 'DoxygenUpdate', 'DoxygenStop', 'DoxygenLog', 'DoxygenTempDoxyfileOpen' },
    version = false,
    dependencies = {
        {
            'hat0uma/prelive.nvim',
            cmd = { 'PreLiveGo', 'PreLiveStatus', 'PreLiveClose', 'PreLiveCloseAll', 'PreLiveLog' },
            version = false,
            opts = {
                server = { host = '127.0.0.1', port = 0 },
                http = {
                    tcp_max_backlog = 16,
                    tcp_recv_buffer_size = 1024,
                    keep_alive_timeout = 60 * 1000,
                    max_body_size = 1024 * 1024 * 1,
                    max_request_line_size = 1024 * 4,
                    max_header_field_size = 1024 * 4,
                    max_header_num = 100,
                    max_chunk_ext_size = 1024 * 1,
                },
                log = {
                    print_level = vim.log.levels.WARN,
                    file_level = vim.log.levels.DEBUG,
                    max_file_size = 1 * 1024 * 1024,
                    max_backups = 3,
                },
            },
        },
    },
    opts = {
        tempdir = vim.fn.stdpath('cache'),
        update_on_save = true,
        doxygen = {
            cmd = 'doxygen',
            doxyfile_patterns = { 'Doxyfile', 'doc/Doxyfile' },
            fallback_cwd = function()
                return vim.fs.dirname(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
            end,
            override_options = {}, ---@type table<string, string|fun():string>
        },
    },
    cond = require('user_api.check.exists').executable('doxygen'),
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
