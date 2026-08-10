---@module 'lazy'

---@param htype string
---@param func function
---@param opts? ibl.hooks.options
local function reg(htype, func, opts)
  if not opts or require('user_api').check.empty(opts) then
    require('ibl.hooks').register(htype, func)
    return
  end
  require('ibl.hooks').register(htype, func, opts)
end

local Hilite = { ---@type HlDict
  RainbowBlue = { fg = '#61AFEF' },
  RainbowCyan = { fg = '#56B6C2' },
  RainbowGreen = { fg = '#98C379' },
  RainbowOrange = { fg = '#D19A66' },
  RainbowRed = { fg = '#E06C75' },
  RainbowViolet = { fg = '#C678DD' },
  RainbowYellow = { fg = '#E5C07B' },
}
local highlight = vim.tbl_keys(Hilite) ---@type string[]

return { ---@type LazySpec
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  version = false,
  dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
  cond = not require('user_api').check.in_console(),
  config = function()
    reg(require('ibl.hooks').type.HIGHLIGHT_SETUP, function()
      require('user_api').highlight.hl_from_dict(Hilite)
    end)
    require('ibl').setup({
      debounce = 200,
      enabled = true,
      indent = {
        highlight = highlight,
        repeat_linebreak = vim.o.bri and vim.o.briopt ~= '',
        smart_indent_cap = false,
        char = { '╎', '╏', '┆', '┇', '┊', '┋' },
        tab_char = { '▏', '▎', '▍', '▌', '▋', '▊', '▉', '█' },
      },
      scope = { highlight = highlight },
      whitespace = { highlight = { 'Whitespace', 'NonText' }, remove_blankline_trail = false },
    })

    local arg_tbl = { ---@type { [1]: string, [2]: function, [3]?: ibl.hooks.options }[]
      {
        require('ibl.hooks').type.ACTIVE,
        function(bufnr) ---@param bufnr integer
          return vim.api.nvim_buf_line_count(bufnr) < 5000
        end,
      },
      { require('ibl.hooks').type.SCOPE_HIGHLIGHT, require('ibl.hooks').builtin.scope_highlight_from_extmark },
      { require('ibl.hooks').type.SKIP_LINE, require('ibl.hooks').builtin.skip_preproc_lines, { bufnr = 0 } },
    }
    for _, t in ipairs(arg_tbl) do
      local htype, func, opts = t[1], t[2], t[3] or nil
      if opts then
        reg(htype, func, opts)
      else
        reg(htype, func)
      end
    end

    if vim.g.rainbow_delimiters and not vim.tbl_isempty(vim.g.rainbow_delimiters) then
      vim.g.rainbow_delimiters = vim.tbl_deep_extend('force', vim.g.rainbow_delimiters, { highlight = highlight })
    end
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
