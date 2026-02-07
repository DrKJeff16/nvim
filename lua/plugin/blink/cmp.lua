---@module 'lazy'

---@param idx integer
---@return fun(cmp: blink.cmp.API): boolean|nil
local function accept_nth(idx)
  require('user_api.check.exists').validate({ idx = { idx, { 'number' } } })
  if not require('user_api.check.value').is_int(idx) then
    error(('Bad index `%d`'):format(idx), vim.log.levels.ERROR)
  end

  return function(cmp) ---@param cmp blink.cmp.API
    return cmp.accept({ index = idx })
  end
end

---@param key string
---@return function
local function gen_termcode_fun(key)
  require('user_api.check.exists').validate({ key = { key, { 'string' } } })

  return function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'i', false)
  end
end

---@param direction 'up'|'down'
---@return fun(cmp: blink.cmp.API): boolean|nil
local function up_or_down(direction)
  require('user_api.check.exists').validate({ direction = { direction, { 'string' } } })
  direction = vim.list_contains({ 'up', 'down' }, direction) and direction or 'up'

  local key = direction == 'up' and '<Up>' or '<Down>'
  return function(cmp) ---@param cmp blink.cmp.API
    if not cmp.is_menu_visible() then
      return
    end
    return cmp.cancel({ callback = gen_termcode_fun(key) })
  end
end

---@class BUtil
local BUtil = {}

BUtil.Sources = {} ---@type string[]
BUtil.Providers = {} ---@type table<string, blink.cmp.SourceProviderConfigPartial>
BUtil.curr_ft = ''

---@param snipps? boolean
---@param buf? boolean
function BUtil.reset_sources(snipps, buf)
  require('user_api.check.exists').validate({
    snipps = { snipps, { 'boolean', 'nil' }, true },
    buf = { buf, { 'boolean', 'nil' }, true },
  })
  snipps = snipps ~= nil and snipps or false
  buf = buf ~= nil and buf or true

  BUtil.Sources = { 'lsp', 'path', 'env' } ---@type string[]
  if snipps then
    table.insert(BUtil.Sources, 'snippets')
  end
  if buf then
    table.insert(BUtil.Sources, 'buffer')
  end

  local ft = require('user_api.util').ft_get(vim.api.nvim_get_current_buf())
  if ft == 'lua' then
    table.insert(BUtil.Sources, 1, 'lazydev')
    return
  end
  if ft == 'sshconfig' then
    table.insert(BUtil.Sources, 1, 'sshconfig')
    return
  end
  if ft == 'tex' then
    table.insert(BUtil.Sources, 1, 'latex')
    return
  end

  local git_fts = { 'git', 'gitcommit', 'gitattributes', 'gitrebase' }
  if vim.list_contains(git_fts, ft) then
    table.insert(BUtil.Sources, 1, 'git')
    if ft == 'gitcommit' then
      table.insert(BUtil.Sources, 1, 'conventional_commits')
    end
  end
end

---@param snipps? boolean
---@param buf? boolean
---@return string[] sources
function BUtil.gen_sources(snipps, buf)
  require('user_api.check.exists').validate({
    snipps = { snipps, { 'boolean', 'nil' }, true },
    buf = { buf, { 'boolean', 'nil' }, true },
  })

  BUtil.reset_sources(snipps, buf)
  return BUtil.Sources
end

function BUtil.reset_providers()
  BUtil.Providers = {
    cmdline = { module = 'blink.cmp.sources.cmdline' },
    buffer = {
      score_offset = -20,
      max_items = 10,
      opts = {
        get_bufnrs = function()
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
        local correct = ''
        local uppercase ---@type boolean
        if not (keyword:match('^%l') or keyword:match('^%u')) then
          return items
        end
        correct = keyword:match('^%l') and '^%u%l+$' or '^%l+$'
        uppercase = keyword:match('^%u') ~= nil

        local seen, out = {}, {}
        for _, item in ipairs(items) do
          local raw = item.insertText
          if raw and raw:match(correct) then
            local text = (uppercase and raw:sub(1, 1):upper() or raw:sub(1, 1):lower())
              .. raw:sub(2)
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
      score_offset = 30,
      opts = {
        trailing_slash = false,
        label_trailing_slash = true,
        ignore_root_slash = false,
        show_hidden_files_by_default = true,
        get_cwd = function(ctx)
          return vim.fn.expand(('#%d:p:h'):format(ctx.bufnr))
        end,
      },
    },
    snippets = {
      name = 'Snippet',
      module = 'blink.cmp.sources.snippets',
      score_offset = -10,
      ---@module 'blink.cmp.sources.snippets'
      ---@type blink.cmp.SnippetsOpts
      opts = { use_show_condition = true, show_autosnippets = false, prefer_doc_trig = false },
      should_show_items = function(ctx)
        return ctx.trigger.initial_kind ~= 'trigger_character'
      end,
    },
    lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
    lsp = {
      name = 'LSP',
      module = 'blink.cmp.sources.lsp',
      score_offset = 70,
      transform_items = function(_, items)
        return vim.tbl_filter(function(value)
          return value.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
        end, items)
      end,
    },
  }

  local exists = require('user_api.check.exists').module
  if exists('css-vars.blink') then
    BUtil.Providers.css_vars = {
      name = 'css-vars',
      module = 'css-vars.blink',
      opts = { search_extensions = { '.js', '.ts', '.jsx', '.tsx' } },
    }
  end
  if exists('blink-cmp-sshconfig') then
    BUtil.Providers.sshconfig = { name = 'SshConfig', module = 'blink-cmp-sshconfig' }
  end
  if exists('blink-cmp-env') then
    BUtil.Providers.env = {
      name = 'Env',
      module = 'blink-cmp-env',
      score_offset = 40,
      opts = {
        item_kind = require('blink.cmp.types').CompletionItemKind.Variable,
        show_braces = false,
        show_documentation_window = true,
      },
    }
  end
  if exists('blink-cmp-git') then
    BUtil.Providers.git = {
      name = 'Git',
      module = 'blink-cmp-git',
      enabled = function()
        local git_fts = { 'git', 'gitcommit', 'gitattributes', 'gitrebase' }
        return vim.list_contains(
          git_fts,
          require('user_api.util').ft_get(vim.api.nvim_get_current_buf())
        )
      end,
      opts = {},
    }
  end
  if exists('blink-cmp-conventional-commits') then
    BUtil.Providers.conventional_commits = {
      name = 'CC',
      module = 'blink-cmp-conventional-commits',
      score_offset = 100,
      enabled = function()
        return require('user_api.util').ft_get(vim.api.nvim_get_current_buf()) == 'gitcommit'
      end,
      opts = {},
    }
  end
  if exists('blink-cmp-latex') then
    BUtil.Providers.latex = {
      name = 'Latex',
      module = 'blink-cmp-latex',
      opts = { insert_command = false },
    }
  end
  if exists('orgmode') then
    BUtil.Providers.orgmode = { name = 'Orgmode', module = 'orgmode.org.autocompletion.blink' }
  end
end

---@param P table<string, blink.cmp.SourceProviderConfigPartial>|nil
---@return table<string, blink.cmp.SourceProviderConfigPartial>
function BUtil.gen_providers(P)
  require('user_api.check.exists').validate({ P = { P, { 'table', 'nil' }, true } })

  BUtil.reset_providers()
  BUtil.Providers = vim.tbl_deep_extend('keep', P or {}, vim.deepcopy(BUtil.Providers))
  return BUtil.Providers
end

local executable = require('user_api.check.exists').executable
return { ---@type LazySpec
  'saghen/blink.cmp',
  event = 'InsertEnter',
  version = false,
  dependencies = {
    'saghen/blink.compat',
    'erooke/blink-cmp-latex',
    {
      'L3MON4D3/LuaSnip',
      version = false,
      dependencies = { 'rafamadriz/friendly-snippets' },
      build = executable('make') and 'make -j $(nproc) install_jsregexp' or false,
      config = function()
        local luasnip = require('luasnip')
        luasnip.config.setup()

        require('luasnip.loaders.from_lua').lazy_load()
        require('luasnip.loaders.from_vscode').lazy_load()

        local extensions = { ---@type table<string, string[]>
          c = { 'cdoc' },
          cpp = { 'cppdoc' },
          cs = { 'csharpdoc' },
          java = { 'javadoc' },
          javascript = { 'jsdoc' },
          kotlin = { 'kdoc' },
          lua = { 'luadoc' },
          php = { 'phpdoc' },
          python = { 'pydoc' },
          ruby = { 'rdoc' },
          rust = { 'rustdoc' },
          sh = { 'shelldoc' },
          typescript = { 'tsdoc' },
        }
        for lang, ext in pairs(extensions) do
          luasnip.filetype_extend(lang, ext)
        end
      end,
    },
    'onsails/lspkind.nvim',
    'folke/lazydev.nvim',
    'jdrupal-dev/css-vars.nvim',
    'Kaiser-Yang/blink-cmp-git',
    'disrupted/blink-cmp-conventional-commits',
    { 'bydlw98/blink-cmp-env', dev = true, version = false },
    {
      'bydlw98/blink-cmp-sshconfig',
      build = executable('uv') and 'make' or false,
      version = false,
    },
  },
  build = executable('cargo') and 'cargo build --release' or false,
  config = function()
    local gen_sources = BUtil.gen_sources
    local gen_providers = BUtil.gen_providers
    pcall(require('luasnip.loaders.from_vscode').lazy_load)

    local select_opts = { auto_insert = true, preselect = false }
    require('blink.cmp').setup({
      enabled = function()
        local disable_in = { 'picker-prompt' }
        return not vim.list_contains(disable_in, vim.bo.filetype)
      end,
      keymap = {
        preset = 'super-tab',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = {
          function(cmp)
            local visible = cmp.is_menu_visible
            if cmp.snippet_active({ direction = 1 }) then
              return cmp.snippet_forward()
            end

            local has_words_before = require('user_api.util').has_words_before
            if not visible() and has_words_before() then
              return cmp.show({ providers = gen_sources(true, true) })
            end
            return cmp.select_next(select_opts)
          end,
          'fallback',
        },
        ['<S-Tab>'] = {
          function(cmp)
            local visible = cmp.is_menu_visible
            if cmp.snippet_active({ direction = -1 }) then
              return cmp.snippet_backward()
            end

            local has_words_before = require('user_api.util').has_words_before
            if not visible() and has_words_before() then
              return cmp.show({ providers = gen_sources(true, true) })
            end
            return cmp.select_prev(select_opts)
          end,
          'fallback',
        },
        ['<A-1>'] = { accept_nth(1), 'fallback' },
        ['<A-2>'] = { accept_nth(2), 'fallback' },
        ['<A-3>'] = { accept_nth(3), 'fallback' },
        ['<A-4>'] = { accept_nth(4), 'fallback' },
        ['<A-5>'] = { accept_nth(5), 'fallback' },
        ['<A-6>'] = { accept_nth(6), 'fallback' },
        ['<A-7>'] = { accept_nth(7), 'fallback' },
        ['<A-8>'] = { accept_nth(8), 'fallback' },
        ['<A-9>'] = { accept_nth(9), 'fallback' },
        ['<A-0>'] = { accept_nth(0), 'fallback' },
        ['<Up>'] = { up_or_down('up'), 'fallback' },
        ['<Down>'] = { up_or_down('down'), 'fallback' },
        ['<Left>'] = { 'fallback' },
        ['<Right>'] = { 'fallback' },
        ['<C-p>'] = { 'fallback' },
        ['<C-n>'] = { 'fallback' },
        ['<C-b>'] = {
          function(cmp)
            if cmp.is_documentation_visible() then
              return cmp.scroll_documentation_up(4)
            end
          end,
          'fallback',
        },
        ['<C-f>'] = {
          function(cmp)
            if cmp.is_documentation_visible() then
              return cmp.scroll_documentation_down(4)
            end
          end,
          'fallback',
        },
        ['<C-k>'] = {
          function(cmp)
            if cmp.is_signature_visible() then
              return cmp.hide_signature()
            end
            return cmp.show_signature()
          end,
          'fallback',
        },
      },
      appearance = {
        nerd_font_variant = 'mono',
        highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
        use_nvim_cmp_as_default = false,
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
            border = 'rounded',
            winblend = 0,
            winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
            scrollbar = false,
            direction_priority = {
              menu_north = { 'e', 'w', 'n', 's' },
              menu_south = { 'e', 'w', 's', 'n' },
            },
          },
        },
        keyword = { range = 'full' },
        accept = {
          auto_brackets = { enabled = false },
          create_undo_point = true,
          dot_repeat = true,
        },
        list = {
          cycle = { from_top = true, from_bottom = true },
          selection = {
            auto_insert = true,
            preselect = function()
              return require('blink.cmp').snippet_active({ direction = 1 })
            end,
          },
        },
        menu = {
          auto_show = true,
          border = 'single',
          draw = {
            padding = { 0, 1 },
            treesitter = { 'lsp' },
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
              { 'source_name', gap = 1 },
            },
          },
        },
        ghost_text = { enabled = false },
      },
      cmdline = {
        enabled = false,
        keymap = {
          preset = 'cmdline',
          ['<Right>'] = { 'fallback' },
          ['<Left>'] = { 'fallback' },
          ['<C-p>'] = { 'fallback' },
          ['<C-n>'] = { 'fallback' },
        },
        completion = {
          ghost_text = { enabled = false },
          list = { selection = { preselect = false, auto_insert = true } },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          if vim.list_contains({ '/', '?' }, type) then
            return { 'buffer' }
          end
          if vim.list_contains({ ':', '@' }, type) then
            return { 'cmdline', 'buffer' }
          end
          return {}
        end,
      },
      sources = {
        providers = gen_providers(),
        default = function()
          return gen_sources(true, true)
        end,
        transform_items = function(_, items)
          return items
        end,
      },
      fuzzy = {
        max_typos = function(keyword) ---@param keyword string
          return math.floor(keyword:len() / 3)
        end,
        sorts = { 'exact', 'score', 'sort_text' },
        implementation = executable('cargo') and 'prefer_rust_with_warning' or 'lua',
      },
      snippets = {
        preset = 'luasnip',
        expand = function(snippet)
          vim.snippet.expand(snippet)
        end,
        active = function(filter)
          return vim.snippet.active(filter)
        end,
        jump = function(direction) ---@param direction integer
          vim.snippet.jump(direction)
        end,
      },
      signature = {
        enabled = true,
        trigger = {
          enabled = false,
          show_on_keyword = false,
          blocked_trigger_characters = {},
          blocked_retrigger_characters = {},
          show_on_trigger_character = true,
          show_on_insert = false,
          show_on_insert_on_trigger_character = true,
        },
        window = {
          treesitter_highlighting = true,
          show_documentation = true,
          border = 'single',
          scrollbar = false,
          direction_priority = { 'n', 's' },
        },
      },
      term = { enabled = false },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
