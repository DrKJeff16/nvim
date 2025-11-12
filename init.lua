_G.MYVIMRC = vim.fn.stdpath('config') .. '/init.lua'
_G.is_windows = vim.fn.has('win32') == 1
_G.inspect = vim.inspect

local ft_get = require('user_api.util').ft_get
local bt_get = require('user_api.util').bt_get

local INFO = vim.log.levels.INFO
local in_list = vim.list_contains

---[SOURCE](https://stackoverflow.com/questions/7183998/in-lua-what-is-the-right-way-to-handle-varargs-which-contains-nil).
---@param ... any
function _G.notify_inspect(...)
    local nargs = select('#', ...) ---@type integer
    local txt = ''
    local i = 1
    while i <= nargs do
        local selection = select(i, ...)
        if not in_list({ 'string', 'number', 'boolean' }, type(selection)) then
            selection = vim.inspect(selection)
        end

        txt = ('%s' .. (i == 1 and '' or '\n') .. '%s'):format(txt, selection)
        i = i + 1
    end
    vim.notify(txt, INFO)
end

vim.g.loaded_perl_provider = 0

require('user_api').opts({
    autoread = true,
    background = 'dark',
    backspace = 'indent,eol,start',
    backup = false,
    cmdwinheight = require('user_api.distro.termux').validate() and 15 or 25,
    colorcolumn = '100',
    confirm = true,
    copyindent = true,
    equalalways = true,
    errorbells = false,
    expandtab = true,
    fileformat = 'unix',
    fileignorecase = not _G.is_windows,
    foldmethod = 'manual',
    formatoptions = 'bjlnopqw',
    helplang = 'en',
    hidden = true,
    hlsearch = true,
    inccommand = 'nosplit',
    ignorecase = false,
    incsearch = true,
    list = true,
    matchpairs = '(:),[:],{:},<:>',
    matchtime = 30,
    menuitems = 50,
    mouse = '',
    number = true,
    preserveindent = true,
    relativenumber = false,
    rightleft = false,
    ruler = true,
    scrolloff = 2,
    secure = false,
    sessionoptions = 'buffers,tabpages,globals',
    shiftwidth = 4,
    showmatch = true,
    showmode = false,
    showtabline = 2,
    signcolumn = 'yes',
    softtabstop = 4,
    spell = false,
    splitbelow = true,
    splitkeep = 'screen',
    splitright = true,
    switchbuf = 'usetab',
    tabstop = 4,
    textwidth = 100,
    title = true,
    wrap = require('user_api.distro.termux').validate(),
})

require('user_api.opts').set_cursor_blink()

---Set `<Leader>` key.
require('user_api.config.keymaps').set_leader('<Space>')

---Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

---Uncomment to use system clipboard
-- vim.o.clipboard = 'unnamedplus'

local L = require('config.lazy')
L.setup({
    { import = 'plugin.startuptime' },
    { import = 'plugin.mini.icons' },
    { import = 'plugin.web-devicons' },
    { import = 'plugin.which-key' },
    { import = 'plugin.notify' },
    { import = 'plugin.noice' },
    { import = 'plugin.luaref' },
    { import = 'plugin.fzf-lua' },
    { import = 'plugin._spec' },
    { import = 'plugin.mason' },
    { import = 'plugin.blink-indent' },
    { import = 'plugin.lastplace' },
    { import = 'plugin.mini.basics' },
    { import = 'plugin.mini.extra' },
    { import = 'plugin.mini.starter' },
    { import = 'plugin.mini.splitjoin' },
    { import = 'plugin.mini.move' },
    { import = 'plugin.lspkind' },
    { import = 'plugin.blink_cmp' },
    { import = 'plugin.project' },
    { import = 'plugin.lazydev' },
    { import = 'plugin.Comment' },
    { import = 'plugin.yanky' },
    { import = 'plugin.paredit' },
    { import = 'plugin.persistence' },
    { import = 'plugin.scope' },
    { import = 'plugin.possession' },
    { import = 'plugin.markdown.render' },
    { import = 'plugin.markdown.outline' },
    { import = 'plugin.autopairs' },
    { import = 'plugin.smart-backspace' },
    { import = 'plugin.ts-comments' },
    { import = 'plugin.neo-tree' },
    { import = 'plugin.snacks' },
    { import = 'plugin.lsp.clangd' },
    { import = 'plugin.gitsigns' },
    { import = 'plugin.lazygit' },
    { import = 'plugin.diffview' },
    { import = 'plugin.mini.diff' },
    { import = 'plugin.mini.bufremove' },
    { import = 'plugin.mini.trailspace' },
    { import = 'plugin.toggleterm' },
    { import = 'plugin.screenkey' },
    { import = 'plugin.hoversplit' },
    { import = 'plugin.outline' },
    { import = 'plugin.lualine' },
    { import = 'plugin.bufferline' },
    { import = 'plugin.fzf-nerdfont' },
    { import = 'plugin.zen-mode' },
    { import = 'plugin.todo_comments' },
    { import = 'plugin.doxygen-previewer' },
    { import = 'plugin.co-author' },
    { import = 'plugin.triforce' },
    { import = 'plugin.helpview' },
    -- { import = 'plugin.buffer-sticks' },
    -- { import = 'plugin.orgmode' },
    -- { import = 'plugin.ibl' },
    -- { import = 'plugin.doxygen' },
    -- { import = 'plugin.pomo' },
    -- { import = 'plugin.gh-co' },
    -- { import = 'plugin.replua' },
    -- { import = 'plugin.log-highlight' },
    -- { import = 'plugin.dooku' },
    -- { import = 'plugin.nvim-test' },
    -- { import = 'plugin.mini.test' },
    -- { import = 'plugin.picker' },
    -- { import = 'plugin.markdoc' },
    -- { import = 'plugin.code-runner' },
    -- { import = 'plugin.scrollbar' },
    -- { import = 'plugin.refactoring' },
    -- { import = 'plugin.checkmate' },
    -- { import = 'plugin.fyler' },
    -- { import = 'plugin.a_vim' },
    -- { import = 'plugin.twilight' },
    -- { import = 'plugin.qwahl' },
    -- { import = 'plugin.undotree' },
})

local desc = require('user_api.maps').desc
require('user_api.config').keymaps({
    n = {
        ['<leader>vM'] = { vim.cmd.messages, desc('Run `:messages`') },
        ['<leader>vN'] = { vim.cmd.Notifications, desc('Run `:Notifications`') },
        ['<C-/>'] = {
            function()
                vim.cmd.norm('gcc')
            end,
            desc('Toggle Comment'),
        },
    },
    v = { ['<C-/>'] = { [[:'<,'>normal gcc<CR>]], desc('Toggle Comment') } },
}, nil, true)

-- Initialize the User API
require('user_api').setup()

local Color = L.colorschemes()
Color('Tokyonight')
-- Color('Thorn')
-- Color('Nightfox')
-- Color('Conifer')
-- Color('Tokyodark')
-- Color('Catppuccin')
-- Color('Spaceduck')

vim.cmd.packadd('nohlsearch')

if vim.fn.has('nvim-0.12.0') == 1 then
    vim.cmd.packadd('nvim.undotree')
end

L.lsp().setup()

local func = vim.schedule_wrap(function()
    local DISABLE_BT = { 'help', 'prompt', 'quickfix', 'terminal' }
    local DISABLE_FT = {
        'help',
        'lazy',
        'checkhealth',
        'notify',
        'qf',
        'TelescopePrompt',
        'TelescopeResults',
        'Redir',
    }

    local bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    if not (in_list(DISABLE_FT, ft_get(bufnr)) or in_list(DISABLE_BT, bt_get(bufnr))) then
        return
    end

    vim.keymap.set('n', 'q', vim.cmd.bdelete, { noremap = true, silent = true, buffer = bufnr })
    vim.wo[win].number = false
    vim.wo[win].signcolumn = 'no'
end)

func()
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
