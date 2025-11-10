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
            local kinds = vim.lsp.protocol.CompletionItemKind ---@type table<string, string>
            for s, kind in next, kinds do
                kinds[s] = require('user_api.check.value').type_not_empty('string', self.icons[s])
                        and self.icons[s]
                    or kind
            end
        end,
    })
end

return Kinds.new()
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
