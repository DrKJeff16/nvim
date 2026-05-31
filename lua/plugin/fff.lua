---@module 'lazy'
return { ---@type LazySpec
  'dmtrKovalenko/fff',
  lazy = false,
  build = function()
    require('fff.download').download_or_build_binary()
  end,
  config = function()
    local FFF = require('fff')
    FFF.setup({
      prompt = '> ',
      title = 'FFFiles',
      max_results = 100,
      max_threads = 4,
      lazy_sync = true,
      prompt_vim_mode = false,
      layout = {
        height = 0.8,
        width = 0.8,
        prompt_position = 'bottom', ---@type 'bottom'|'top'
        preview_position = 'right', ---@type 'left'|'right'|'top'|'bottom'
        preview_size = 0.5,
        flex = { size = 130, wrap = 'top' },
        min_list_height = 10,
        show_scrollbar = true,
        path_shorten_strategy = 'middle_number', ---@type'middle_number'|'middle'|'end'|'start'
        anchor = 'center',
      },
      preview = {
        enabled = true,
        max_size = 10 * 1024 * 1024,
        chunk_size = 8192,
        binary_file_threshold = 1024,
        imagemagick_info_format_str = '%m: %wx%h, %[colorspace], %q-bit',
        line_numbers = false,
        cursorlineopt = 'both',
        wrap_lines = false,
        filetypes = { svg = { wrap_lines = true }, markdown = { wrap_lines = true }, text = { wrap_lines = true } },
      },
      keymaps = {
        close = '<Esc>',
        select = '<CR>',
        select_split = '<C-s>',
        select_vsplit = '<C-v>',
        select_tab = '<C-t>',
        move_up = '<Up>',
        move_down = '<Down>',
        preview_scroll_up = '<C-u>',
        preview_scroll_down = '<C-d>',
        toggle_debug = '<F2>',
        cycle_grep_modes = '<S-Tab>',
        cycle_previous_query = '<C-Up>',
        toggle_select = '<Tab>',
        send_to_quickfix = '<C-q>',
        focus_list = '<leader>l',
        focus_preview = '<leader>p',
      },
      frecency = { enabled = true, db_path = vim.fs.joinpath(vim.fn.stdpath('cache'), 'fff_nvim') },
      history = {
        enabled = true,
        db_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'fff_queries'),
        min_combo_count = 3,
        combo_boost_score_multiplier = 100,
      },
      git = { status_text_color = true },
      grep = {
        max_file_size = 10 * 1024 * 1024,
        max_matches_per_file = 100,
        smart_case = true,
        time_budget_ms = 150,
        modes = { 'plain', 'regex', 'fuzzy' },
        trim_whitespace = false,
      },
      debug = {
        enabled = false,
        show_scores = false,
        show_file_info = { file_info = true, score_breakdown = true, timings = true, full_path = true },
      },
      logging = { enabled = true, log_file = vim.fs.joinpath(vim.fn.stdpath('log'), 'fff.log'), log_level = 'info' },
    })

    local desc = require('user_api').maps.desc
    require('user_api').config.keymaps.set({
      n = {
        f = { group = 'FFF' },
        fc = {
          function()
            FFF.live_grep({ query = vim.fn.expand('<cword>') })
          end,
          desc('Search current word'),
        },
        ff = { FFF.find_files, desc('FFFind files') },
        fg = { FFF.live_grep, desc('LiFFFe grep') },
        fz = {
          function()
            FFF.live_grep({ grep = { modes = { 'fuzzy', 'plain' } } })
          end,
          desc('Live fffuzy grep'),
        },
      },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
