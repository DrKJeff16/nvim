---@module 'lazy'

return { ---@type LazySpec
    'julienvincent/nvim-paredit',
    version = false,
    config = function()
        local Paredit = require('nvim-paredit')
        local API = Paredit.api
        Paredit.setup({
            use_default_keys = false,
            filetypes = { 'clojure', 'fennel', 'scheme', 'lisp', 'janet' },
            languages = {
                clojure = { whitespace_chars = { ' ', ',' } },
                fennel = { whitekpace_chars = { ' ', ',' } },
            },
            cursor_behaviour = 'auto', ---@type 'remain'|'follow'|'auto'
            dragging = { auto_drag_pairs = true },
            indent = {
                enabled = true,
                indentor = require('nvim-paredit.indentation.native').indentor,
            },
            keys = {
                ['<localleader>o'] = false,
                ['<localleader>O'] = false,
                ['<localleader>@'] = { Paredit.unwrap.unwrap_form_under_cursor, 'Splice sexp' },
                ['<localleader>Po'] = { API.raise_form, 'Raise form' },
                ['<localleader>PO'] = { API.raise_element, 'Raise element' },
                ['>p'] = { API.drag_pair_forwards, 'Drag element pairs right' },
                ['<p'] = { API.drag_pair_backwards, 'Drag element pairs left' },
                ['>)'] = { API.slurp_forwards, 'Slurp forwards' },
                ['>('] = { API.barf_backwards, 'Barf backwards' },
                ['<)'] = { API.barf_forwards, 'Barf forwards' },
                ['<('] = { API.slurp_backwards, 'Slurp backwards' },
                ['>e'] = { API.drag_element_forwards, 'Drag element right' },
                ['<e'] = { API.drag_element_backwards, 'Drag element left' },
                ['>f'] = { API.drag_form_forwards, 'Drag form right' },
                ['<f'] = { API.drag_form_backwards, 'Drag form left' },
                ['if'] = { API.select_in_form, 'In form', repeatable = false, mode = { 'o', 'v' } },
                ie = { API.select_element, 'Element', repeatable = false, mode = { 'o', 'v' } },
                E = {
                    API.move_to_next_element_tail,
                    'Jump to next element tail',
                    repeatable = false,
                    mode = { 'n', 'x', 'o', 'v' },
                },
                W = {
                    API.move_to_next_element_head,
                    'Jump to next element head',
                    repeatable = false,
                    mode = { 'n', 'x', 'o', 'v' },
                },
                B = {
                    API.move_to_prev_element_head,
                    'Jump to previous element head',
                    repeatable = false,
                    mode = { 'n', 'x', 'o', 'v' },
                },
                gE = {
                    API.move_to_prev_element_tail,
                    'Jump to previous element tail',
                    repeatable = false,
                    mode = { 'n', 'x', 'o', 'v' },
                },
                ['('] = {
                    API.move_to_parent_form_start,
                    "Jump to parent form's head",
                    repeatable = false,
                    mode = { 'n', 'x', 'v' },
                },
                [')'] = {
                    API.move_to_parent_form_end,
                    "Jump to parent form's tail",
                    repeatable = false,
                    mode = { 'n', 'x', 'v' },
                },
                af = {
                    API.select_around_form,
                    'Around form',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
                aF = {
                    API.select_around_top_level_form,
                    'Around top level form',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
                iF = {
                    API.select_in_top_level_form,
                    'In top level form',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
                ae = {
                    API.select_element,
                    'Around element',
                    repeatable = false,
                    mode = { 'o', 'v' },
                },
            },
        })
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
