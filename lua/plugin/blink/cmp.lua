---@module 'lazy'
---@module 'blink.lib'
---@diagnostic disable:duplicate-set-field

local User = require('user_api')

---@param idx integer
---@return fun(cmp: blink.cmp.API): result: boolean|nil|?
local function accept_nth(idx)
  User.check.validate({ idx = { idx, { 'number' } } })
  if not User.check.is_int(idx) then
    error(('Bad index `%d`'):format(idx), vim.log.levels.ERROR)
  end

  return function(cmp) ---@param cmp blink.cmp.API
    return cmp.accept({ index = idx })
  end
end

---@class BUtil
_G.BUtil = {}

function _G.BUtil.gen_providers()
  _G.BLINK_PROVIDERS = { ---@type table<string, blink.cmp.SourceProviderConfigPartial>
    cmdline = { module = 'blink.cmp.sources.cmdline' },
    snippets = { max_items = 5, module = 'blink.cmp.sources.snippets', score_offset = -75 },
    buffer = {
      max_items = 5,
      opts = {
        enable_in_ex_commands = false,
        get_bufnrs = function() ---@return integer[]
          return vim
            .iter(vim.api.nvim_list_wins())
            :map(function(win) ---@param win integer
              return vim.api.nvim_win_get_buf(win) ---@diagnostic disable-line:missing-return-value
            end)
            :filter(function(bufnr) ---@param bufnr integer
              return vim.bo[bufnr].buftype ~= 'nofile'
            end)
            :totable()
        end,
        get_search_bufnrs = function() ---@return integer[]
          return { vim.api.nvim_get_current_buf() }
        end,
        max_async_buffer_size = 200000,
        max_sync_buffer_size = 20000,
        max_total_buffer_size = 500000,
        retention_order = { 'focused', 'visible', 'recency', 'largest' },
        use_cache = true,
      },
      score_offset = -70,
      ---@param ctx blink.cmp.Context
      ---@param items blink.cmp.CompletionItem[]
      transform_items = function(ctx, items)
        local keyword = ctx.get_keyword()
        if not (keyword:match('^%l') or keyword:match('^%u')) then
          return items
        end

        local seen, out = {}, {} ---@type table<string, boolean>, blink.cmp.CompletionItem[]
        for _, item in ipairs(items) do
          if item.insertText and item.insertText:match(keyword:match('^%l') and '^%u%l+$' or '^%l+$') then
            local text = (keyword:match('^%u') ~= nil and string.upper or string.lower)(item.insertText:sub(1, 1))
              .. item.insertText:sub(2)
            item.insertText, item.label = text, text
          end
          if not seen[item.insertText] then
            seen[item.insertText] = true
            table.insert(out, item)
          end
        end
        return out
      end,
    },
    path = {
      module = 'blink.cmp.sources.path',
      name = 'Path',
      opts = {
        get_cwd = function()
          return (vim.uv or vim.loop).cwd() or vim.fn.getcwd()
        end,
        ignore_root_slash = false,
        label_trailing_slash = true,
        show_hidden_files_by_default = true,
        trailing_slash = false,
      },
      score_offset = 50,
    },
    lazydev = { module = 'lazydev.integrations.blink', name = 'LazyDev', score_offset = 100 },
    lsp = { module = 'blink.cmp.sources.lsp', name = 'LSP', score_offset = 80 },
    orgmode = { name = 'Org', module = 'orgmode.org.autocompletion.blink' },
    css_vars = {
      module = 'css-vars.blink',
      name = 'css-vars',
      opts = { search_extensions = { '.js', '.ts', '.jsx', '.tsx' } },
    },
    sshconfig = { module = 'blink-cmp-sshconfig', name = 'SshConfig' },
    git = {
      enabled = function()
        return vim.list_contains({ 'git', 'gitcommit', 'gitattributes', 'gitrebase' }, vim.bo.ft)
      end,
      module = 'blink-cmp-git',
      name = 'Git',
    },
    conventional_commits = {
      enabled = function()
        return vim.bo.ft == 'gitcommit'
      end,
      module = 'blink-cmp-conventional-commits',
      name = 'CC',
      score_offset = 100,
    },
    env = {
      module = 'blink-cmp-env',
      name = 'Env',
      opts = {
        item_kind = require('blink.cmp.types').CompletionItemKind.Variable,
        show_braces = false,
        show_documentation_window = true,
      },
    },
  }

  return _G.BLINK_PROVIDERS
end

_G.BLINK_SOURCES = {} ---@type string[]

---@param opts? { cmdline: boolean }| { terminal: boolean }
---@return string[] sources
_G.BUtil.gen_sources = function(opts)
  opts = opts or {}

  _G.BLINK_SOURCES = {}
  if opts.cmdline then
    _G.BLINK_SOURCES = (function()
      local type = vim.fn.getcmdtype()
      local res = {} ---@type string[]
      if vim.list_contains({ '/', '?' }, type) then -- Search forward and backward
        res = { 'buffer' }
      elseif vim.list_contains({ ':', '@' }, type) then -- Commands
        res = { 'cmdline', 'buffer' }
      end
      return res
    end)()
  elseif not opts.terminal then
    _G.BLINK_SOURCES = {
      'lazydev',
      'lsp',
      'path',
      'buffer',
      'snippets',
      'git',
      'css_vars',
      'conventional_commits',
      'env',
      'sshconfig',
      'orgmode',
    } --[[@as string[]\]]
  end
  return _G.BLINK_SOURCES
end

return { ---@type LazySpec[]
  {
    'L3MON4D3/LuaSnip',
    version = false,
    build = User.check.executable('make') and 'make install_jsregexp' or false,
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip').setup()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  {
    'saghen/blink.cmp',
    version = false,
    build = function()
      require('blink.cmp').build():wait(60000)
    end,
    cond = User.check.executable('cargo') and vim.fn.has('nvim-0.12') == 1,
    dependencies = { 'saghen/blink.lib', 'onsails/lspkind.nvim', 'L3MON4D3/LuaSnip' },
    config = function()
      require('blink.cmp').setup({
        enabled = function()
          return not vim.list_contains({ 'picker-prompt' }, vim.bo.ft)
        end,
        keymap = {
          preset = 'cmdline',
          ['<A-0>'] = { accept_nth(0), 'fallback' },
          ['<A-1>'] = { accept_nth(1), 'fallback' },
          ['<A-2>'] = { accept_nth(2), 'fallback' },
          ['<A-3>'] = { accept_nth(3), 'fallback' },
          ['<A-4>'] = { accept_nth(4), 'fallback' },
          ['<A-5>'] = { accept_nth(5), 'fallback' },
          ['<A-6>'] = { accept_nth(6), 'fallback' },
          ['<A-7>'] = { accept_nth(7), 'fallback' },
          ['<A-8>'] = { accept_nth(8), 'fallback' },
          ['<A-9>'] = { accept_nth(9), 'fallback' },
          ['<C-Space>'] = {
            function(cmp)
              return cmp.is_visible() and cmp.hide() or cmp.show({ providers = _G.BUtil.gen_sources() })
            end,
            'fallback',
          },
          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-e>'] = { 'cancel', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
          ['<CR>'] = {
            function(cmp)
              return cmp.is_active() and cmp.accept() or false
            end,
            'fallback',
          },
          ['<S-Tab>'] = {
            function(cmp)
              return cmp.snippet_active() and cmp.snippet_backward()
                or (
                  cmp.is_menu_visible() and cmp.select_prev()
                  or (User.util.has_words_before() and cmp.show({ providers = _G.BUtil.gen_sources() }) or false)
                )
            end,
            'fallback',
          },
          ['<Tab>'] = {
            function(cmp)
              return cmp.snippet_active() and cmp.snippet_forward()
                or (
                  cmp.is_menu_visible() and cmp.select_next()
                  or (User.util.has_words_before() and cmp.show({ providers = _G.BUtil.gen_sources() }) or false)
                )
            end,
            'fallback',
          },
          ['<C-n>'] = false,
          ['<C-p>'] = false,
          ['<Down>'] = false,
          ['<End>'] = false,
          ['<Home>'] = false,
          ['<Left>'] = false,
          ['<Right>'] = false,
          ['<Up>'] = false,
        },
        appearance = {
          highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
          kind_icons = require('lspkind').symbol_map,
          nerd_font_variant = 'mono',
        },
        completion = {
          accept = { auto_brackets = { enabled = false }, create_undo_point = true, dot_repeat = true },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            treesitter_highlighting = true,
            update_delay_ms = 100,
            window = {
              direction_priority = { menu_north = { 'e', 'w', 'n', 's' }, menu_south = { 'e', 'w', 's', 'n' } },
              scrollbar = true,
              winblend = 0,
              winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
            },
          },
          keyword = { range = 'full' },
          list = {
            cycle = { from_bottom = true, from_top = true },
            max_items = 300,
            selection = {
              auto_insert = true,
              preselect = function()
                return require('blink.cmp').snippet_active({ direction = 1 })
              end,
            },
          },
          menu = {
            auto_show = true,
            auto_show_delay_ms = 0,
            border = 'rounded',
            cmdline_position = function()
              if vim.g.ui_cmdline_pos then
                return { vim.g.ui_cmdline_pos[1] - 1, vim.g.ui_cmdline_pos[2] }
              end
              return { vim.o.lines - ((vim.o.cmdheight == 0) and 1 or vim.o.cmdheight), 0 }
            end,
            direction_priority = { 's', 'n' },
            draw = {
              align_to = 'cursor',
              columns = {
                { 'label', 'label_description', gap = 1 },
                { 'kind_icon', 'kind' },
                { 'source_name', gap = 1 },
              },
              components = {
                kind = {
                  highlight = function(ctx)
                    local _, hl = require('mini.icons').get('lsp', ctx.kind)
                    return hl
                  end,
                },
                kind_icon = {
                  highlight = function(ctx)
                    local _, hl = require('mini.icons').get('lsp', ctx.kind)
                    return hl
                  end,
                  text = function(ctx)
                    return (require('mini.icons').get('lsp', ctx.kind))
                  end,
                },
              },
              treesitter = { 'lua', 'markdown' },
            },
            enabled = true,
            max_height = 15,
            min_width = 15,
          },
          ghost_text = { enabled = false },
          trigger = { show_in_snippet = true, show_on_trigger_character = true },
        },
        sources = {
          default = _G.BUtil.gen_sources(),
          providers = _G.BUtil.gen_providers(),
          transform_items = function(_, items)
            return items
          end,
        },
        fuzzy = {
          implementation = 'prefer_rust',
          max_typos = function(keyword)
            return math.floor(keyword:len() / 3)
          end,
          sorts = { 'exact', 'score', 'sort_text', 'label' },
        },
        snippets = { preset = 'luasnip' },
        signature = {
          enabled = true,
          trigger = {
            blocked_retrigger_characters = {},
            blocked_trigger_characters = {},
            enabled = true,
            show_on_accept_on_trigger_character = true,
            show_on_keyword = true,
            show_on_trigger_character = true,
          },
          window = {
            border = 'rounded',
            direction_priority = { 's', 'n' },
            scrollbar = true,
            show_documentation = true,
            treesitter_highlighting = true,
          },
        },
        cmdline = {
          enabled = false,
          keymap = {
            preset = 'cmdline',
            ['<S-Tab>'] = {
              function(cmp)
                if not cmp.is_menu_visible() and User.util.has_words_before() then
                  return cmp.show({ providers = _G.BUtil.gen_sources({ cmdline = true }) })
                end
                if cmp.is_menu_visible() then
                  return cmp.select_prev()
                end
                return false
              end,
              'fallback',
            },
            ['<Tab>'] = {
              function(cmp)
                if not cmp.is_menu_visible() and User.util.has_words_before() then
                  return cmp.show({ providers = _G.BUtil.gen_sources({ cmdline = true }) })
                end
                if cmp.is_menu_visible() then
                  return cmp.select_next()
                end
                return false
              end,
              'fallback',
            },
            ['<Left>'] = false,
            ['<Right>'] = false,
            ['<Up>'] = false,
            ['<Down>'] = false,
          },
        },
        term = { enabled = false },
      })
    end,
  },
  {
    'jdrupal-dev/css-vars.nvim',
    ft = { 'css', 'less', 'scss' },
    version = false,
    cond = require('user_api').check.executable('rg'),
    dependencies = { 'saghen/blink.cmp' },
  },
  {
    'Kaiser-Yang/blink-cmp-git',
    ft = { 'git', 'gitcommit', 'gitattributes', 'gitconfig', 'gitignore', 'gitrebase' },
    version = false,
    dependencies = { 'saghen/blink.cmp' },
  },
  {
    'disrupted/blink-cmp-conventional-commits',
    ft = 'gitcommit',
    version = false,
    dependencies = { 'saghen/blink.cmp' },
  },
  {
    'bydlw98/blink-cmp-env',
    dev = true,
    version = false,
    dependencies = { 'saghen/blink.cmp' },
  },
  {
    'bydlw98/blink-cmp-sshconfig',
    ft = 'sshconfig',
    version = false,
    build = User.check.executable('uv') and 'make' or false,
    dependencies = { 'saghen/blink.cmp' },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
