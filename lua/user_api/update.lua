local MODSTR = 'user_api.update'
local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO

---@class User.Update
local Update = {}

---@param verbose? boolean
---@return string?
function Update.update(verbose)
    if vim.fn.has('nvim-0.11') then
        vim.validate('verbose', verbose, 'boolean', true)
    else
        vim.validate({ verbose = { verbose, { 'boolean', 'nil' } } })
    end
    verbose = verbose ~= nil and verbose or false

    local og_cwd = vim.fn.getcwd()
    local cmd = { 'git', 'pull', '--rebase', '--recurse-submodules' }
    vim.api.nvim_set_current_dir(vim.fn.stdpath('config'))
    local res = vim.fn.system(cmd)
    vim.api.nvim_set_current_dir(og_cwd)
    local lvl = res:match('error') and WARN or INFO
    if verbose then
        vim.notify(res, lvl, {
            animate = true,
            hide_from_history = false,
            timeout = 2250,
            title = 'User API - Update',
        })
    end
    if vim.v.shell_error ~= 0 then
        vim.notify(
            ('(%s.update): Failed to update Jnvim, try to do it manually'):format(MODSTR),
            WARN
        )
        return
    end
    if res:match('Already up to date') then
        vim.notify(('(%s.update): Jnvim is up to date!'):format(MODSTR), INFO, {
            animate = true,
            hide_from_history = true,
            timeout = 1750,
            title = 'User API - Update',
        })
    elseif not res:match('error') then
        vim.notify(('(%s.update): You need to restart Nvim!'):format(MODSTR), WARN, {
            animate = true,
            hide_from_history = false,
            timeout = 5000,
            title = 'User API - Update',
        })
    end
    return res
end

function Update.setup()
    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
        n = {
            ['<leader>U'] = { group = '+User API' },
            ['<leader>Uu'] = { Update.update, desc('Update User Config') },
            ['<leader>UU'] = {
                function()
                    Update.update(true)
                end,
                desc('Update User Config (Verbose)'),
            },
        },
    })

    vim.api.nvim_create_user_command('UserUpdate', function(ctx)
        Update.update(ctx.bang)
    end, { bang = true, desc = 'Update Jnvim' })
end

return Update
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
