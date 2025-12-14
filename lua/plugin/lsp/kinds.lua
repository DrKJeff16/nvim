---@class Lsp.SubMods.Kinds
local Kinds = {}

---@class Lsp.SubMods.Kinds.Icons
Kinds.icons = {
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

---@return Lsp.SubMods.Kinds|function
function Kinds.new()
    return setmetatable({}, {
        __index = Kinds,
        __call = function(self) ---@param self Lsp.SubMods.Kinds
            for s, kind in pairs(vim.lsp.protocol.CompletionItemKind) do
                local icon = self.icons[s] or kind ---@type Lsp.SubMods.Kinds.Icons|lsp.CompletionItemKind
                vim.lsp.protocol.CompletionItemKind[s] = icon ~= '' and icon or kind
            end
        end,
    })
end

return Kinds.new()
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
