local uv = vim.uv or vim.loop
local d_extend = vim.tbl_deep_extend
local fs_stat = uv.fs_stat

local cfg = vim.fn.stdpath('config')
local luarocks_path = vim.fn.expand('~/.luarocks/share/lua/5.1')

---@param client vim.lsp.Client
local function on_init(client)
  if not client.workspace_folders or vim.tbl_isempty(client.workspace_folders) then
    return
  end
  local path = client.workspace_folders[1].name
  for _, v in ipairs({ vim.fs.joinpath(path, 'luarc.json'), vim.fs.joinpath(path, '.luarc.json') }) do
    if path ~= cfg and fs_stat(v) then
      return
    end
  end

  local library = {
    vim.env.VIMRUNTIME,
    vim.fs.joinpath(vim.env.VIMRUNTIME, 'lua'),
    vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
    '${3rd}/luv/library',
    '${3rd}/busted/library',
    -- vim.api.nvim_get_runtime_file('', true),
    -- luarocks_path,
  }

  client.config.settings.Lua = d_extend('force', client.config.settings.Lua or {}, {
    completion = {
      autoRequire = false,
      callSnippet = 'Replace',
      displayContext = 12,
      enable = true,
      keywordSnippet = 'Replace',
      postfix = '@',
      requireSeparator = '.',
      showParams = true,
      showWord = 'Fallback',
      workspaceWord = true,
    },
    diagnostics = {
      enable = true,
      globals = { 'vim' },
      libraryFiles = 'Disable',
      workspaceEvent = 'OnChange',
    },
    runtime = {
      version = 'LuaJIT',
      path = {
        'lua/?.lua',
        'lua/?/init.lua',
        vim.fs.joinpath(vim.env.VIMRUNTIME, 'lua/?.lua'),
        vim.fs.joinpath(vim.env.VIMRUNTIME, 'lua/?/init.lua'),
      },
    },
    workspace = { checkThirdParty = false, useGitIgnore = true, library = library },
  })
end

return { ---@type vim.lsp.ClientConfig
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  on_init = on_init,
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', '.git' },
  settings = {
    Lua = {
      addonManager = { enable = false },
      codeLens = { enable = false },
      completion = {
        autoRequire = false,
        callSnippet = 'Replace',
        displayContext = 12,
        enable = true,
        keywordSnippet = 'Replace',
        postfix = '@',
        requireSeparator = '.',
        showParams = true,
        showWord = 'Fallback',
        workspaceWord = true,
      },
      diagnostics = { enable = true },
      format = { enable = false },
      hint = {
        arrayIndex = 'Enable',
        await = true,
        enable = true,
        paramName = 'All',
        paramType = true,
        semicolon = 'SameLine',
        setType = true,
      },
      hover = {
        enable = true,
        enumsLimit = 75,
        expandAlias = true,
        previewFields = 70,
        viewNumber = true,
        viewString = true,
        viewStringMax = 500,
      },
      language = { completeAnnotation = true, fixIndent = true },
      runtime = {
        fileEncoding = 'utf8',
        pathStrict = false,
        unicodeName = false,
        path = { 'lua/?.lua', 'lua/?/init.lua' },
      },
      semantic = { annotation = true, enable = true, keyword = true, variable = true },
      signatureHelp = { enable = true },
      type = {
        castNumberToInteger = false,
        inferParamType = true,
        weakNilCheck = true,
        weakUnionCheck = true,
        inferTableSize = true,
      },
      window = { progressBar = true, statusBar = true },
      workspace = {
        checkThirdParty = false,
        useGitIgnore = true,
        ignoreSubmodules = true,
        library = {
          -- vim.env.VIMRUNTIME,
          -- vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
          luarocks_path,
          '${3rd}/luv/library',
          '${3rd}/busted/library',
        },
      },
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
