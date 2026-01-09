---@module 'lazy'
---@module 'render-markdown'
return { ---@type LazySpec
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
  cond = not require('user_api.check').in_console(),
  opts = { ---@type render.md.UserConfig
    enabled = true,
    completions = { lsp = { enabled = true } },
    render_modes = { 'n', 'c', 't' },
    max_file_size = 10.0,
    debounce = 100,
    restart_highlighter = true,
    win_options = {
      conceallevel = { default = vim.o.conceallevel, rendered = 3 },
      concealcursor = { default = vim.o.concealcursor, rendered = '' },
    },
    overrides = {
      buflisted = {},
      buftype = { nofile = { code = { left_pad = 0, right_pad = 0 } } },
      filetype = {},
    },
    markdown = {
      disable = true,
      directives = {
        { id = 17, name = 'conceal_lines' },
        { id = 18, name = 'conceal_lines' },
      },
    },
    callout = {
      note = {
        raw = '[!NOTE]',
        rendered = '󰋽 Note',
        highlight = 'RenderMarkdownInfo',
        category = 'github',
      },
      tip = {
        raw = '[!TIP]',
        rendered = '󰌶 Tip',
        highlight = 'RenderMarkdownSuccess',
        category = 'github',
      },
      important = {
        raw = '[!IMPORTANT]',
        rendered = '󰅾 Important',
        highlight = 'RenderMarkdownHint',
        category = 'github',
      },
      warning = {
        raw = '[!WARNING]',
        rendered = '󰀪 Warning',
        highlight = 'RenderMarkdownWarn',
        category = 'github',
      },
      caution = {
        raw = '[!CAUTION]',
        rendered = '󰳦 Caution',
        highlight = 'RenderMarkdownError',
        category = 'github',
      },
      -- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
      abstract = {
        raw = '[!ABSTRACT]',
        rendered = '󰨸 Abstract',
        highlight = 'RenderMarkdownInfo',
        category = 'obsidian',
      },
      summary = {
        raw = '[!SUMMARY]',
        rendered = '󰨸 Summary',
        highlight = 'RenderMarkdownInfo',
        category = 'obsidian',
      },
      tldr = {
        raw = '[!TLDR]',
        rendered = '󰨸 Tldr',
        highlight = 'RenderMarkdownInfo',
        category = 'obsidian',
      },
      info = {
        raw = '[!INFO]',
        rendered = '󰋽 Info',
        highlight = 'RenderMarkdownInfo',
        category = 'obsidian',
      },
      todo = {
        raw = '[!TODO]',
        rendered = '󰗡 Todo',
        highlight = 'RenderMarkdownInfo',
        category = 'obsidian',
      },
      hint = {
        raw = '[!HINT]',
        rendered = '󰌶 Hint',
        highlight = 'RenderMarkdownSuccess',
        category = 'obsidian',
      },
      success = {
        raw = '[!SUCCESS]',
        rendered = '󰄬 Success',
        highlight = 'RenderMarkdownSuccess',
        category = 'obsidian',
      },
      check = {
        raw = '[!CHECK]',
        rendered = '󰄬 Check',
        highlight = 'RenderMarkdownSuccess',
        category = 'obsidian',
      },
      done = {
        raw = '[!DONE]',
        rendered = '󰄬 Done',
        highlight = 'RenderMarkdownSuccess',
        category = 'obsidian',
      },
      question = {
        raw = '[!QUESTION]',
        rendered = '󰘥 Question',
        highlight = 'RenderMarkdownWarn',
        category = 'obsidian',
      },
      help = {
        raw = '[!HELP]',
        rendered = '󰘥 Help',
        highlight = 'RenderMarkdownWarn',
        category = 'obsidian',
      },
      faq = {
        raw = '[!FAQ]',
        rendered = '󰘥 Faq',
        highlight = 'RenderMarkdownWarn',
        category = 'obsidian',
      },
      attention = {
        raw = '[!ATTENTION]',
        rendered = '󰀪 Attention',
        highlight = 'RenderMarkdownWarn',
        category = 'obsidian',
      },
      failure = {
        raw = '[!FAILURE]',
        rendered = '󰅖 Failure',
        highlight = 'RenderMarkdownError',
        category = 'obsidian',
      },
      fail = {
        raw = '[!FAIL]',
        rendered = '󰅖 Fail',
        highlight = 'RenderMarkdownError',
        category = 'obsidian',
      },
      missing = {
        raw = '[!MISSING]',
        rendered = '󰅖 Missing',
        highlight = 'RenderMarkdownError',
        category = 'obsidian',
      },
      danger = {
        raw = '[!DANGER]',
        rendered = '󱐌 Danger',
        highlight = 'RenderMarkdownError',
        category = 'obsidian',
      },
      error = {
        raw = '[!ERROR]',
        rendered = '󱐌 Error',
        highlight = 'RenderMarkdownError',
        category = 'obsidian',
      },
      bug = {
        raw = '[!BUG]',
        rendered = '󰨰 Bug',
        highlight = 'RenderMarkdownError',
        category = 'obsidian',
      },
      example = {
        raw = '[!EXAMPLE]',
        rendered = '󰉹 Example',
        highlight = 'RenderMarkdownHint',
        category = 'obsidian',
      },
      quote = {
        raw = '[!QUOTE]',
        rendered = '󱆨 Quote',
        highlight = 'RenderMarkdownQuote',
        category = 'obsidian',
      },
      cite = {
        raw = '[!CITE]',
        rendered = '󱆨 Cite',
        highlight = 'RenderMarkdownQuote',
        category = 'obsidian',
      },
    },
    link = {
      enabled = true,
      render_modes = false,
      footnote = {
        enabled = true,
        icon = '󰯔 ',
        superscript = true,
        prefix = '',
        suffix = '',
      },
      image = '󰥶 ',
      email = '󰀓 ',
      hyperlink = '󰌹 ',
      highlight = 'RenderMarkdownLink',
      wiki = {
        icon = '󱗖 ',
        body = function()
          return nil
        end,
        highlight = 'RenderMarkdownWikiLink',
        scope_highlight = nil,
      },
      custom = {
        web = { pattern = '^http', icon = '󰖟 ' },
        apple = { pattern = 'apple%.com', icon = ' ' },
        discord = { pattern = 'discord%.com', icon = '󰙯 ' },
        github = { pattern = 'github%.com', icon = '󰊤 ' },
        gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
        google = { pattern = 'google%.com', icon = '󰊭 ' },
        hackernews = { pattern = 'ycombinator%.com', icon = ' ' },
        linkedin = { pattern = 'linkedin%.com', icon = '󰌻 ' },
        microsoft = { pattern = 'microsoft%.com', icon = ' ' },
        neovim = { pattern = 'neovim%.io', icon = ' ' },
        reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
        slack = { pattern = 'slack%.com', icon = '󰒱 ' },
        stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
        steam = { pattern = 'steampowered%.com', icon = ' ' },
        twitter = { pattern = 'x%.com', icon = ' ' },
        wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
        youtube = { pattern = 'youtube[^.]*%.com', icon = '󰗃 ' },
        youtube_short = { pattern = 'youtu%.be', icon = '󰗃 ' },
      },
    },
    injections = {
      gitcommit = {
        enabled = true,
        query = [[
                ((message) @injection.content
                    (#set! injection.combined)
                    (#set! injection.include-children)
                    (#set! injection.language "markdown"))
                ]],
      },
    },
    indent = {
      enabled = false,
      render_modes = false,
      per_level = 2,
      skip_level = 1,
      skip_heading = false,
      icon = '▎',
      priority = 0,
      highlight = 'RenderMarkdownIndent',
    },
    anti_conceal = {
      enabled = true,
      disabled_modes = false,
      above = 0,
      below = 0,
      ignore = {
        code_background = true,
        indent = true,
        sign = true,
        virtual_lines = true,
      },
    },
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
