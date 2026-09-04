---@param bufnr integer
---@param client vim.lsp.Client
local function symbol_info(bufnr, client)
  local method_name = 'textDocument/symbolInfo'
  ---@diagnostic disable-next-line:param-type-mismatch
  if not client or not client:supports_method(method_name) then
    vim.notify('Clangd client not found', vim.log.levels.ERROR)
    return
  end

  local win = vim.api.nvim_get_current_win()
  ---@diagnostic disable-next-line:param-type-mismatch
  client:request(method_name, vim.lsp.util.make_position_params(win, client.offset_encoding), function(err, res)
    if err or #res == 0 then
      return
    end
    local container = ('container: %s'):format(res[1].containerName)
    local name = ('name: %s'):format(res[1].name)
    vim.lsp.util.open_floating_preview({ name, container }, '', {
      focus = false,
      focusable = false,
      height = 2,
      title = 'Symbol Info',
      width = math.max(name:len(), container:len()),
    })
  end, bufnr)
end

---@param bufnr integer
---@param client vim.lsp.Client
local function switch_source_header(bufnr, client)
  local method_name = 'textDocument/switchSourceHeader'
  ---@diagnostic disable-next-line:param-type-mismatch
  if not client or not client:supports_method(method_name) then
    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
  end

  ---@diagnostic disable-next-line:param-type-mismatch
  client:request(method_name, vim.lsp.util.make_text_document_params(bufnr), function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify('corresponding file cannot be determined')
    else
      vim.cmd.edit(vim.uri_to_fname(result))
    end
  end, bufnr)
end

return { ---@type vim.lsp.ClientConfig
  capabilities = { offsetEncoding = { 'utf-8', 'utf-16' }, textDocument = { completion = { editsNearCursor = true } } },
  cmd = { 'clangd' },
  filetypes = { 'c', 'c.doxygen', 'cpp', 'cpp.doxygen', 'objc', 'objcpp', 'cuda' },
  get_language_id = function(_, ftype)
    local t = { objc = 'objective-c', objcpp = 'objective-cpp', cuda = 'cuda-cpp' }
    return t[ftype] or ftype
  end,
  root_markers = {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac',
    '.git',
  },
  on_init = function(client, init_result)
    ---@diagnostic disable:undefined-field
    if init_result.offsetEncoding then
      client.offset_encoding = init_result.offsetEncoding
    end
    ---@diagnostic enable:undefined-field
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdSwitchSourceHeader', function()
      switch_source_header(bufnr, client)
    end, { desc = 'Switch between source/header' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdShowSymbolInfo', function()
      symbol_info(bufnr, client)
    end, { desc = 'Show symbol info' })
  end,
  settings = {
    clangd = {
      checkUpdates = false,
      detectExtensionConflicts = true,
      enableCodeCompletion = true,
      onConfigChanged = 'restart',
      path = '/usr/bin/clangd',
      restartAfterCrash = true,
      serverCompletionRanking = false,
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
