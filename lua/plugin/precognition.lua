---@module 'lazy'
return { ---@type LazySpec
  'tris203/precognition.nvim',
  event = 'VeryLazy',
  opts = {
    disabled_fts = { 'startify' },
    gutterHints = {
      G = { prio = 10, text = 'G' },
      NextParagraph = { prio = 8, text = '}' },
      PrevParagraph = { prio = 8, text = '{' },
      gg = { prio = 9, text = 'gg' },
    },
    highlightColor = { link = 'Comment' },
    hints = {
      B = { prio = 6, text = 'B' },
      Caret = { prio = 2, text = '^' },
      Dollar = { prio = 1, text = '$' },
      E = { prio = 5, text = 'E' },
      MatchingPair = { prio = 5, text = '%' },
      W = { prio = 7, text = 'W' },
      Zero = { prio = 1, text = '0' },
      b = { prio = 9, text = 'b' },
      e = { prio = 8, text = 'e' },
      w = { prio = 10, text = 'w' },
    },
    showBlankVirtLine = true,
    startVisible = true,
  },
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
