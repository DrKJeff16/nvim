---@module 'lazy'
return { ---@type LazySpec
  'aserowy/tmux.nvim',
  config = function()
    require('tmux').setup({
      copy_sync = {
        enable = true,
        ignore_buffers = { empty = false },
        redirect_to_clipboard = false,
        register_offset = 0,
        sync_clipboard = true,
        sync_registers = true,
        sync_registers_keymap_put = true,
        sync_registers_keymap_reg = true,
        sync_deletes = true,
        sync_unnamed = true,
      },
      navigation = {
        cycle_navigation = true,
        enable_default_keybindings = true,
        persist_zoom = false,
      },
      resize = { enable_default_keybindings = true, resize_step_x = 1, resize_step_y = 1 },
      swap = { cycle_navigation = false, enable_default_keybindings = true },
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
