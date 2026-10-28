---@module 'lazy'
return { ---@type LazySpec
  'b0o/SchemaStore.nvim',
  ft = { 'json', 'yaml', 'toml' },
  version = false,
  config = function()
    vim.lsp.config('yaml', {
      settings = { yaml = { schemaStore = { url = '' }, schemas = require('schemastore').yaml.schemas() } },
    })
    vim.lsp.config('jsonls', {
      settings = { json = { schemas = require('schemastore').json.schemas(), validate = { enable = true } } },
    })
  end,
}
