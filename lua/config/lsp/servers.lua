---@param name string
---@param exe string|nil
---@return vim.lsp.Config|nil config
---@overload fun(name: string): server: vim.lsp.Config|nil
local function server_load(name, exe)
  require('user_api.check').validate({
    name = { name, 'string' },
    exe = { exe, { 'string', 'nil' }, true },
  })
  exe = exe or name
  exe = exe ~= '' and exe or name
  if not require('user_api.check.exists').executable(exe) then
    return
  end

  ---@type boolean, vim.lsp.Config|nil
  local ok, mod = pcall(require, 'config.lsp.servers.' .. name)
  if ok and mod then
    return mod
  end
end

---@class Lsp.Server.Clients
local Clients = {
  -- stylua = server_load('stylua'),
  -- emmylua_ls = server_load('emmylua_ls'),
  lua_ls = server_load('lua_ls', 'lua-language-server'),

  asm_lsp = server_load('asm_lsp', 'asm-lsp'),
  autotools_ls = server_load('autotools_ls', 'autotools-language-server'),
  bashls = server_load('bashls', 'bash-language-server'),
  clangd = server_load('clangd'),
  cmake = server_load('cmake', 'cmake-language-server'),
  cspell_ls = server_load('cspell_ls', 'cspell-lsp'),
  css_variables = server_load('css_variables', 'css-variables-language-server'),
  cssls = server_load('cssls', 'vscode-css-language-server'),
  cssmodules_ls = server_load('cssmodules_ls', 'cssmodules-language-server'),
  docker_compose_language_service = server_load(
    'docker_compose_language_service',
    'docker-compose-langserver'
  ),
  docker_language_server = server_load('docker_language_server', 'docker-language-server'),
  dockerls = server_load('dockerls', 'docker-langserver'),
  gh_actions_ls = server_load('gh_actions_ls', 'gh-action-language-server'),
  html = server_load('html', 'vscode-html-language-server'),
  hyprls = server_load('hyprls'),
  jdtls = server_load('jdtls'),
  jsonls = server_load('jsonls', 'vscode-json-language-server'),
  julials = server_load('julials', 'julia'),
  marksman = server_load('marksman'),
  pylsp = server_load('pylsp'),
  ruby_lsp = server_load('ruby_lsp', 'ruby-lsp'),
  rust_analyzer = server_load('rust_analyzer', 'rust-analyzer'),
  systemd_lsp = server_load('systemd_lsp', 'systemd-lsp'),
  taplo = server_load('taplo'),
  texlab = server_load('texlab'),
  vimls = server_load('vimls', 'vim-language-server'),
  yamlls = server_load('yamlls', 'yaml-language-server'),
}

return Clients
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
