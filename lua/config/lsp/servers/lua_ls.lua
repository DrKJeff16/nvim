local uv = vim.uv or vim.loop
local d_extend = vim.tbl_deep_extend
local fs_stat = uv.fs_stat

local cfg = vim.fn.stdpath('config')
local luarocks_path = vim.fn.expand('~/.luarocks/share/lua/5.1')

---@param client vim.lsp.Client
local function on_init(client, _)
  if not client.workspace_folders or vim.tbl_isempty(client.workspace_folders) then
    return
  end
  local path = client.workspace_folders[1].name
  local luarc = { path .. '/luarc.json', path .. '/.luarc.json' }
  if path ~= cfg and (fs_stat(luarc[1]) or fs_stat(luarc[2])) then
    return
  end

  local library = {
    vim.env.VIMRUNTIME,
    -- luarocks_path,
    '${3rd}/luv/library',
    '${3rd}/busted/library',
  }

  client.config.settings.Lua = d_extend('force', client.config.settings.Lua or {}, {
    diagnostics = { enable = true, globals = { 'vim' } },
    runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
    workspace = { checkThirdParty = false, useGitIgnore = true, library = library },
  })
end

return { ---@type vim.lsp.ClientConfig
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  on_init = on_init,
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    '.git',
  },
  settings = {
    Lua = {
      addonManager = { enable = true },
      codeLens = { enable = true },
      completion = {
        autoRequire = false,
        callSnippet = 'Replace',
        displayContext = 12,
        enable = true,
        keywordSnippet = 'Replace',
        postfix = '@',
        requireSeparator = '.',
        showParams = true,
        showWord = 'Enable',
        workspaceWord = true,
      },
      diagnostics = { enable = true, libraryFiles = 'Opened' },
      format = { enable = false },
      hint = {
        arrayIndex = 'Auto',
        await = true,
        enable = true,
        paramName = 'All',
        paramType = true,
        semicolon = 'SameLine',
        setType = true,
      },
      hover = {
        enable = true,
        enumsLimit = 50,
        expandAlias = true,
        previewFields = 50,
        viewNumber = true,
        viewString = true,
        viewStringMax = 1000,
      },
      runtime = {
        fileEncoding = 'utf8',
        pathStrict = false,
        unicodeName = false,
        path = {
          '?.lua',
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      semantic = { annotation = true, enable = true, keyword = true, variable = true },
      signatureHelp = { enable = true },
      type = {
        castNumberToInteger = false,
        inferParamType = true,
        weakNilCheck = true,
        weakUnionCheck = true,
      },
      window = { progressBar = false, statusBar = false },
      workspace = {
        checkThirdParty = false,
        useGitIgnore = true,
        library = { luarocks_path },
      },
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
