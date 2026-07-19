---@module 'lazy'
---@module 'blink.lib'

local User = require('user_api')

---@param idx integer
---@return fun(cmp: blink.cmp.API): result: boolean|nil|?
local function accept_nth(idx)
  User.check.validate({ idx = { idx, { 'number' } } })
  if not require('user_api').check.is_int(idx) then
    error(('Bad index `%d`'):format(idx), vim.log.levels.ERROR)
  end

  return function(cmp) ---@param cmp blink.cmp.API
    return cmp.accept({ index = idx })
  end
end

---@class BUtil
local BUtil = {}

local Providers = {} ---@type table<string, blink.cmp.SourceProviderConfigPartial>
local Sources = {} ---@type string[]

---@param opts? { cmdline: boolean }| { terminal: boolean }
function BUtil.reset_sources(opts)
  opts = opts or {}

  if opts.cmdline then
    Sources = (function()
      local type = vim.fn.getcmdtype()
      -- Search forward and backward
      if type == '/' or type == '?' then
        return { 'buffer' }
      end
      -- Commands
      if type == ':' or type == '@' then
        return { 'cmdline', 'buffer' }
      end
      return {}
    end)()
    return
  end
  if opts.terminal then
    Sources = {}
    return
  end
  Sources = { 'lazydev', 'lsp', 'path', 'buffer', 'snippets' } --[[@as string[]\]]

  local ft = User.util.ft_get(vim.api.nvim_get_current_buf())
  if ft == 'sshconfig' then
    table.insert(Sources, 1, 'sshconfig')
    return
  end
  if ft == 'tex' then
    table.insert(Sources, 1, 'latex')
    return
  end

  local git_fts = { 'git', 'gitcommit', 'gitattributes', 'gitrebase' }
  if vim.list_contains(git_fts, ft) then
    table.insert(Sources, 1, 'git')
    if ft == 'gitcommit' then
      table.insert(Sources, 1, 'conventional_commits')
    end
  end
end

---@param opts? { cmdline: boolean }| { terminal: boolean }
---@return string[] sources
function BUtil.gen_sources(opts)
  BUtil.reset_sources(opts)
  return Sources
end

function BUtil.reset_providers()
  Providers = {
    cmdline = { module = 'blink.cmp.sources.cmdline' },
    snippets = { score_offset = -75, max_items = 5, module = 'blink.cmp.sources.snippets' },
    buffer = {
      score_offset = -70,
      max_items = 5,
      opts = {
        get_bufnrs = function() ---@return table
          return vim
            .iter(vim.api.nvim_list_wins())
            :map(function(win) ---@param win integer
              return vim.api.nvim_win_get_buf(win)
            end)
            :filter(function(bufnr) ---@param bufnr integer
              return vim.api.nvim_get_option_value('buftype', { buf = bufnr }) ~= 'nofile'
            end)
            :totable()
        end,
        get_search_bufnrs = function() ---@return integer[]
          return { vim.api.nvim_get_current_buf() }
        end,
        max_sync_buffer_size = 20000,
        max_async_buffer_size = 200000,
        max_total_buffer_size = 500000,
        retention_order = { 'focused', 'visible', 'recency', 'largest' },
        use_cache = true,
        enable_in_ex_commands = false,
      },
      ---@param ctx blink.cmp.Context
      ---@param items blink.cmp.CompletionItem[]
      transform_items = function(ctx, items)
        local keyword = ctx.get_keyword()
        if not (keyword:match('^%l') or keyword:match('^%u')) then
          return items
        end
        local correct = keyword:match('^%l') and '^%u%l+$' or '^%l+$'
        local uppercase = keyword:match('^%u') ~= nil

        local seen, out = {}, {} ---@type table<string, boolean>, blink.cmp.CompletionItem[]
        for _, item in ipairs(items) do
          local raw = item.insertText
          if raw and raw:match(correct) then
            local text = (uppercase and raw:sub(1, 1):upper() or raw:sub(1, 1):lower()) .. raw:sub(2)
            item.insertText = text
            item.label = text
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
      name = 'Path',
      module = 'blink.cmp.sources.path',
      score_offset = 50,
      opts = {
        trailing_slash = false,
        label_trailing_slash = true,
        ignore_root_slash = true,
        show_hidden_files_by_default = true,
        get_cwd = function()
          return vim.fn.getcwd()
        end,
      },
    },
    lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
    lsp = { name = 'LSP', module = 'blink.cmp.sources.lsp', score_offset = 80 },
  }

  if User.check.module('css-vars.blink') then
    Providers.css_vars = {
      name = 'css-vars',
      module = 'css-vars.blink',
      opts = { search_extensions = { '.js', '.ts', '.jsx', '.tsx' } },
    }
  end
  if User.check.module('blink-cmp-sshconfig') then
    Providers.sshconfig = { name = 'SshConfig', module = 'blink-cmp-sshconfig' }
  end
  if User.check.module('blink-cmp-git') then
    Providers.git = {
      name = 'Git',
      module = 'blink-cmp-git',
      enabled = function()
        local git_fts = { 'git', 'gitcommit', 'gitattributes', 'gitrebase' }
        return vim.list_contains(git_fts, User.util.ft_get(vim.api.nvim_get_current_buf()))
      end,
    }
  end
  if User.check.module('blink-cmp-conventional-commits') then
    Providers.conventional_commits = {
      name = 'CC',
      module = 'blink-cmp-conventional-commits',
      score_offset = 100,
      enabled = function()
        return User.util.ft_get(vim.api.nvim_get_current_buf()) == 'gitcommit'
      end,
    }
  end
  if User.check.module('blink-cmp-latex') then
    Providers.latex = {
      name = 'Latex',
      module = 'blink-cmp-latex',
      opts = { insert_command = false },
    }
  end
  if User.check.module('orgmode') then
    Providers.orgmode = { name = 'Org', module = 'orgmode.org.autocompletion.blink' }
  end
end

---@param P? table<string, blink.cmp.SourceProviderConfigPartial>
---@return table<string, blink.cmp.SourceProviderConfigPartial> providers
function BUtil.gen_providers(P)
  User.check.validate({ P = { P, { 'table', 'nil' }, true } })

  BUtil.reset_providers()
  Providers = vim.tbl_deep_extend('keep', P or {}, Providers)
  return Providers
end

return { ---@type LazySpec
  'saghen/blink.cmp',
  event = 'InsertEnter',
  version = false,
  dependencies = {
    'saghen/blink.lib',
    'onsails/lspkind.nvim',
    'folke/lazydev.nvim',
    'rafamadriz/friendly-snippets',
    'jdrupal-dev/css-vars.nvim',
    'Kaiser-Yang/blink-cmp-git',
    'disrupted/blink-cmp-conventional-commits',
    {
      'L3MON4D3/LuaSnip',
      version = false,
      build = User.check.executable('make') and 'make install_jsregexp' or false,
      config = function()
        require('luasnip').setup()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    { 'bydlw98/blink-cmp-env', dev = true, version = false },
    { 'bydlw98/blink-cmp-sshconfig', build = User.check.executable('uv') and 'make' or false, version = false },
  },
  build = function()
    require('blink.cmp').build():wait(60000)
  end,
  config = function()
    require('blink.cmp').setup({
      enabled = function()
        return not vim.list_contains({ 'picker-prompt' }, vim.bo.filetype)
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
            if cmp.is_visible() then
              return cmp.hide()
            end
            return cmp.show({ providers = BUtil.gen_sources() })
          end,
          'fallback',
        },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        ['<CR>'] = {
          function(cmp)
            if cmp.is_active() then
              return cmp.accept()
            end
            return false
          end,
          'fallback',
        },
        ['<S-Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_backward()
            end
            if not cmp.is_menu_visible() and require('user_api').util.has_words_before() then
              return cmp.show({ providers = BUtil.gen_sources() })
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
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            end
            if not cmp.is_menu_visible() and require('user_api').util.has_words_before() then
              return cmp.show({ providers = BUtil.gen_sources() })
            end
            if cmp.is_menu_visible() then
              return cmp.select_next()
            end
            return false
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
        nerd_font_variant = 'mono',
        highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
        kind_icons = require('lspkind').symbol_map,
      },
      completion = {
        trigger = { show_in_snippet = true, show_on_trigger_character = true },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          update_delay_ms = 100,
          treesitter_highlighting = true,
          window = {
            winblend = 0,
            winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
            scrollbar = true,
            direction_priority = { menu_north = { 'e', 'w', 'n', 's' }, menu_south = { 'e', 'w', 's', 'n' } },
          },
        },
        keyword = { range = 'full' },
        accept = { auto_brackets = { enabled = false }, create_undo_point = true, dot_repeat = true },
        list = {
          max_items = 300,
          cycle = { from_top = true, from_bottom = true },
          selection = {
            auto_insert = true,
            preselect = function()
              return require('blink.cmp').snippet_active({ direction = 1 })
            end,
          },
        },
        menu = {
          enabled = true,
          border = 'rounded',
          min_width = 15,
          max_height = 15,
          auto_show = true,
          direction_priority = { 's', 'n' },
          auto_show_delay_ms = 0,
          cmdline_position = function()
            if vim.g.ui_cmdline_pos then
              return { vim.g.ui_cmdline_pos[1] - 1, vim.g.ui_cmdline_pos[2] }
            end
            return { vim.o.lines - ((vim.o.cmdheight == 0) and 1 or vim.o.cmdheight), 0 }
          end,
          draw = {
            align_to = 'cursor',
            treesitter = { 'lua', 'markdown' },
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
              { 'source_name', gap = 1 },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon = require('mini.icons').get('lsp', ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  local _, hl = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        ghost_text = { enabled = false },
      },
      sources = {
        providers = BUtil.gen_providers(),
        default = BUtil.gen_sources(),
        transform_items = function(_, items)
          return items
        end,
      },
      fuzzy = {
        max_typos = function(keyword)
          return math.floor(keyword:len() / 3)
        end,
        sorts = { 'exact', 'score', 'sort_text', 'label' },
        implementation = 'prefer_rust',
      },
      snippets = { preset = 'luasnip' },
      signature = {
        enabled = true,
        trigger = {
          enabled = true,
          blocked_retrigger_characters = {},
          blocked_trigger_characters = {},
          show_on_accept_on_trigger_character = true,
          show_on_keyword = true,
          show_on_trigger_character = true,
        },
        window = {
          border = 'rounded',
          treesitter_highlighting = true,
          show_documentation = true,
          scrollbar = true,
          direction_priority = { 's', 'n' },
        },
      },
      cmdline = {
        enabled = false,
        keymap = {
          preset = 'cmdline',
          ['<S-Tab>'] = {
            function(cmp)
              if not cmp.is_menu_visible() and require('user_api').util.has_words_before() then
                return cmp.show({ providers = BUtil.gen_sources({ cmdline = true }) })
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
              if not cmp.is_menu_visible() and require('user_api').util.has_words_before() then
                return cmp.show({ providers = BUtil.gen_sources({ cmdline = true }) })
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
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
