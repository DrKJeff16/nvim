---@module 'lazy'
return { ---@type LazySpec
  'hat0uma/doxygen-previewer.nvim',
  version = false,
  dependencies = {
    {
      'hat0uma/prelive.nvim',
      lazy = true,
      version = false,
      opts = {
        server = {
          host = '127.0.0.1',
          port = (function()
            local port = 22
            while port == 22 do
              port = math.random(0, 65535)
            end
            return port
          end)(),
        },
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
  config = function()
    require('doxygen-previewer').setup({
      tempdir = vim.fn.stdpath('cache'),
      update_on_save = true,
      doxygen = {
        cmd = 'doxygen',
        doxyfile_patterns = { 'Doxyfile', 'doc/Doxyfile' },
        fallback_cwd = function()
          return vim.fs.dirname(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        end,
        override_options = {}, ---@type table<string, string|fun(): string>
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
