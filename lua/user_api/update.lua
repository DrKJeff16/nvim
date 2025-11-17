local MODSTR = 'user_api.update'
local WARN = vim.log.levels.WARN
local ERROR = vim.log.levels.ERROR
local INFO = vim.log.levels.INFO

---@class User.Update
local Update = {}

---@param verbose boolean|nil
function Update.update(verbose)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('verbose', verbose, 'boolean', true)
    else
        vim.validate({ verbose = { verbose, { 'boolean', 'nil' }, true } })
    end
    verbose = verbose ~= nil and verbose or false

    local og_cwd = vim.fn.getcwd()

    vim.api.nvim_set_current_dir(vim.fn.stdpath('config'))
    local cmd = vim.system({ 'git', 'pull', '--rebase', '--recurse-submodules' }, { text = true })
        :wait(5000)

    local stdout, stderr = cmd.stdout, cmd.stderr
    vim.api.nvim_set_current_dir(og_cwd)
    if verbose then
        vim.notify((cmd.code ~= 0 and stderr or stdout), cmd.code ~= 0 and WARN or INFO, {
            animate = true,
            hide_from_history = false,
            timeout = 2250,
            title = 'User API - Update',
        })
    end
    if cmd.code ~= 0 then
        vim.notify(('Failed to update Jnvim, try to do it manually'):format(MODSTR), ERROR, {
            animate = true,
            hide_from_history = false,
            timeout = 5000,
            title = 'User API - Update',
        })
        return
    end

    if stdout and stdout:match('Already up to date') then
        vim.notify(('(%s.update): Jnvim is up to date!'):format(MODSTR), INFO, {
            animate = true,
            hide_from_history = true,
            timeout = 1750,
            title = 'User API - Update',
        })
        return
    end
    vim.notify(('(%s.update): You need to restart Nvim!'):format(MODSTR), WARN, {
        animate = true,
        hide_from_history = false,
        timeout = 5000,
        title = 'User API - Update',
    })
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
