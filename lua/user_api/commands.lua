---@class User.Commands.CmdSpec
---@field [1] fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@field [2]? vim.api.keyset.user_command
---@field mappings? AllModeMaps

local desc = require('user_api.maps').desc

---@class User.Commands
local Commands = {
    commands = { ---@type table<string, User.Commands.CmdSpec>
        Redir = {
            function(ctx)
                local l = vim.split(
                    vim.api.nvim_exec2(ctx.args, { output = true }).output,
                    '\n',
                    { plain = true }
                )
                local bufnr = vim.api.nvim_create_buf(true, true)
                local win = vim.api.nvim_open_win(bufnr, true, { vertical = false })
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, l)
                vim.bo[bufnr].filetype = 'Redir'
                vim.bo[bufnr].modified = false
                vim.wo[win].number = false
                vim.wo[win].signcolumn = 'no'

                vim.keymap.set('n', 'q', function()
                    vim.api.nvim_buf_delete(bufnr, { force = true })
                    pcall(vim.api.nvim_win_close, win, true)
                end, { buffer = bufnr })

                vim.schedule(function()
                    vim.cmd.wincmd('=')
                end)
            end,
            {
                nargs = '+',
                complete = 'command',
                desc = 'Redirect command output to scratch buffer',
            },
            mappings = {
                n = {
                    ['<Leader>UC'] = { group = '+Commands' },
                    ['<Leader>UCR'] = { ':Redir ', desc('Prompt to `Redir` command', false) },
                    ['<M-r>'] = { ':Redir ', desc('Prompt `Redir`', false) },
                },
            },
        },
        DeleteInactiveBuffers = {
            function(ctx)
                local notify = ctx.bang ~= nil and ctx.bang or false
                for _, buf in ipairs(vim.fn.getbufinfo()) do
                    if vim.tbl_isempty(buf.windows) and buf.listed == 1 and buf.loaded == 1 then
                        notify = true
                        vim.cmd.bdelete({ buf.bufnr, bang = true })
                    end
                end
                if notify then
                    vim.notify('Deleted inactive buffers.', vim.log.levels.INFO)
                end
            end,
            { desc = 'Delete listed unmodified buffers out of window', bang = true },
        },
    },
}

---@param name string
---@param cmd fun(ctx?: vim.api.keyset.create_user_command.command_args)
---@param opts? vim.api.keyset.user_command
---@param mappings? AllModeMaps
function Commands.add_command(name, cmd, opts, mappings)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('name', name, { 'string' }, false)
        vim.validate('cmd', cmd, { 'function' }, false)
        vim.validate('opts', opts, { 'table', 'nil' }, true, 'vim.api.keyset.user_command')
        vim.validate('mappings', mappings, { 'table', 'nil' }, true, 'AllModeMaps')
    else
        vim.validate({
            name = { name, { 'string' } },
            cmd = { cmd, { 'function' } },
            opts = { opts, { 'table', 'nil' }, true },
            mappings = { mappings, { 'table', 'nil' }, true },
        })
    end

    local cmnd = { cmd, opts or {} } ---@type User.Commands.CmdSpec
    if mappings then
        cmnd.mappings = mappings
    end
    Commands.setup({ [name] = cmnd })
end

function Commands.setup_keys()
    local Keymaps = require('user_api.config').keymaps
    for _, cmd in pairs(Commands.commands) do
        if cmd.mappings and not vim.tbl_isempty(cmd.mappings) then
            Keymaps(cmd.mappings)
        end
    end
end

---@param cmds? table<string, User.Commands.CmdSpec>
function Commands.setup(cmds)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('cmds', cmds, { 'table', 'nil' }, true, 'User.Commands.Spec')
    else
        vim.validate({ cmds = { cmds, { 'table', 'nil' }, true } })
    end

    Commands.commands = vim.tbl_deep_extend('keep', cmds or {}, vim.deepcopy(Commands.commands))
    for cmd, T in pairs(Commands.commands) do
        local exec, opts = T[1], T[2] or {}
        vim.api.nvim_create_user_command(cmd, exec, opts)
    end

    Commands.setup_keys()
end

local M = setmetatable(Commands, { ---@type User.Commands
    __index = Commands,
    __newindex = function()
        vim.notify('User.Commands is Read-Only!', vim.log.levels.ERROR)
    end,
})

return M
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
