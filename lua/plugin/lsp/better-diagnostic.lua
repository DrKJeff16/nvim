---@module 'lazy'

return { ---@type LazySpec
    'sontungexpt/better-diagnostic-virtual-text',
    event = 'LspAttach',
    version = false,
    config = function()
        require('better-diagnostic-virtual-text').setup({
            ui = {
                wrap_line_after = false, -- wrap the line after this length to avoid the virtual text is too long
                left_kept_space = 3, --- the number of spaces kept on the left side of the virtual text, make sure it enough to custom for each line
                right_kept_space = 3, --- the number of spaces kept on the right side of the virtual text, make sure it enough to custom for each line
                arrow = '  ',
                up_arrow = '  ',
                down_arrow = '  ',
                above = false, -- the virtual text will be displayed above the line
            },
            priority = 2003, -- the priority of virtual text
            inline = true,
        })
    end,
}
-- vim: set ts=4 sts=4 sw=4 et ai si sta:
