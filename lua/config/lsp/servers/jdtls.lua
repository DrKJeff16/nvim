---@return string path
local function get_jdtls_cache_dir()
  return vim.fs.joinpath(vim.fn.stdpath('cache'), 'jdtls')
end

---@return string path
local function get_jdtls_workspace_dir()
  return vim.fs.joinpath(get_jdtls_cache_dir(), 'workspace')
end

return { ---@type vim.lsp.ClientConfig
  ---@param dispatchers vim.lsp.rpc.Dispatchers
  ---@param config vim.lsp.ClientConfig
  ---@return vim.lsp.rpc.Client
  cmd = function(dispatchers, config)
    local data_dir = get_jdtls_workspace_dir()
    if config.root_dir then
      data_dir = vim.fs.joinpath(data_dir, vim.fn.fnamemodify(config.root_dir, ':p:h:t'))
    end

    local config_cmd = { ---@type string[]
      'jdtls',
      '-data',
      data_dir,
      (function()
        local args = {} ---@type string[]
        for a in (os.getenv('JDTLS_JVM_ARGS') or ''):gmatch('%S+') do
          table.insert(args, ('--jvm-arg=%s'):format(a))
        end
        return unpack(args)
      end)(),
    }

    return vim.lsp.rpc.start(
      config_cmd,
      dispatchers,
      { cwd = config.cmd_cwd, detached = config.detached, env = config.cmd_env }
    )
  end,
  filetypes = { 'java' },
  root_markers = {
    { 'mvnw', 'gradlew', 'settings.gradle', 'settings.gradle.kts', '.git' },
    { 'build.xml', 'pom.xml', 'build.gradle', 'build.gradle.kts' },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
