---@class Lsp.SubMods.Kinds
local M = {}

---@enum Lsp.SubMods.Kinds.Icons
local icons = {
  Class = ' ',
  Color = ' ',
  Constant = ' ',
  Constructor = ' ',
  Enum = ' ',
  EnumMember = ' ',
  Field = '󰄶 ',
  File = ' ',
  Folder = ' ',
  Function = ' ',
  Interface = '󰜰',
  Keyword = '󰌆 ',
  Method = 'ƒ ',
  Module = '󰏗 ',
  Property = ' ',
  Snippet = '󰘍 ',
  Struct = ' ',
  Text = ' ',
  Unit = ' ',
  Value = '󰎠 ',
  Variable = ' ',
}

function M.setup()
  for s, kind in pairs(vim.lsp.protocol.CompletionItemKind) do
    local icon = icons[s] or kind
    vim.lsp.protocol.CompletionItemKind[s] = icon ~= '' and icon or kind
  end
end

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
