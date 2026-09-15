---@module 'lazy'
---@module 'project'
---@module 'triforce'
---@module 'lualine.components.project'

---@alias SectionComponentStr
---|'branch'
---|'buffers'
---|'datetime'
---|'diagnostics'
---|'diff'
---|'encoding'
---|'fileformat'
---|'filename'
---|'filesize'
---|'filetype'
---|'hostname'
---|'location'
---|'mode'
---|'progress'
---|'searchcount'
---|'selectioncount'
---|'tabs'
---|'windows'
---|string

---@class SectionSeparator
---@field left string
---@field right string

---@class LuaLine.Components.Spec
---@field color? vim.api.keyset.highlight|string
---@field cond? function
---@field draw_empty? boolean
---@field fmt? fun(str: string, context?: any)
---@field icon? string
---@field icons_enabled? boolean
---@field on_click? fun(clicks?: integer, button: string, mods: any)
---@field padding? integer
---@field separator? string|SectionSeparator
---@field type? any

---@class ComponentsColor
---@field active
---|'lualine_a_normal'
---|'lualine_b_normal'
---|'lualine_c_normal'
---|'lualine_x_normal'
---|'lualine_y_normal'
---|'lualine_z_normal'
---@field inactive
---|'lualine_a_inactive'
---|'lualine_b_inactive'
---|'lualine_c_inactive'
---|'lualine_x_inactive'
---|'lualine_y_inactive'
---|'lualine_z_inactive'

---@class BuffersSymbols
---@field alternate_file string
---@field directory string
---@field modified string

---@class LuaLine.Components.Buffers: LuaLine.Components.Spec
---@field [1] 'buffers'
---@field buffers_color? ComponentsColor
---@field filetype_names? table<string, string>
---@field hide_filename_extension? boolean
---@field max_length? number
---@field mode? 0|1|2|3|4
---@field show_filename_only? boolean
---@field show_modified_status? boolean
---@field symbols? BuffersSymbols
---@field use_mode_colors? boolean

---@class LuaLine.Components.DateTime: LuaLine.Components.Spec
---@field [1] 'datetime'
---@field style? 'default'|'us'|'uk'|'iso'|string

---@class DiagnosticsInteger
---@field error? string|integer
---@field hint? string|integer
---@field info? string|integer
---@field warn? string|integer

---@class DiagnosticsColor: DiagnosticsInteger
---@field error? string|integer
---@field hint? string|integer
---@field info? string|integer
---@field warn? string|integer

---@class DiagnosticsSections
---@field [1]? 'error'
---@field [2]? 'warn'
---@field [3]? 'info'
---@field [4]? 'hint'

---@class LuaLine.Components.Diagnostics: LuaLine.Components.Spec
---@field [1] 'diagnostics'
---@field always_visible? boolean
---@field colored? boolean
---@field diagnostics_color? DiagnosticsColor
---@field sections? ('error'|'warn'|'info'|'hint')[]|DiagnosticsSections
---@field sources? ('nvim_lsp'|'nvim_diagnostic'|'nvim_workspace_diagnostic'|'coc'|'ale'|'vim_lsp')[]|fun(...): DiagnosticsInteger
---@field symbols? DiagnosticsColor
---@field update_in_insert? boolean

---@class DiffColor
---@field added string
---@field modified string
---@field removed string

---@class DiffSource: DiffColor
---@field added integer
---@field modified integer
---@field removed integer

---@class LuaLine.Components.Diff: LuaLine.Components.Spec
---@field [1] 'diff'
---@field colored? boolean
---@field diff_color? DiffColor
---@field source? integer|fun(...): (nil|DiffSource)
---@field symbols? DiffColor

---@class FileFormatSymbols
---@field dos string
---@field mac string
---@field unix string

---@class LuaLine.Components.Fileformat: LuaLine.Components.Spec
---@field [1] 'fileformat'
---@field symbols? FileFormatSymbols

---@class FileNameSymbols
---@field modified string
---@field newfile string
---@field readonly string
---@field unnamed string

---@class LuaLine.Components.Filename: LuaLine.Components.Spec
---@field [1] 'filename'
---@field file_status? boolean
---@field newfile_status? boolean
---@field path? 0|1|2|3|4
---@field shorting_target? integer
---@field symbols? FileNameSymbols

---@class FileTypeIcon
---@field [1]? string
---@field align string

---@class LuaLine.Components.Filetype: LuaLine.Components.Spec
---@field [1] 'filetype'
---@field colored? boolean
---@field icon? FileTypeIcon
---@field icon_only? boolean

---@class LuaLine.Components.Searchcount: LuaLine.Components.Spec
---@field [1] 'searchcount'
---@field maxcount? integer
---@field timeout? integer

---@class TabsSymbols
---@field modified string

---@class LuaLine.Components.Tabs: LuaLine.Components.Spec
---@field [1] 'tabs'
---@field fmt? fun(name: string, context: table?): string
---@field max_length? number
---@field mode? 0|1|2
---@field path? 0|1|2|3
---@field show_modified_status? boolean
---@field symbols? TabsSymbols
---@field tab_max_length? integer
---@field tabs_color? ComponentsColor
---@field use_mode_colors? boolean

---@class LuaLine.Components.Windows: LuaLine.Components.Spec
---@field diabled_buftypes? string[]
---@field filetype_names? table<string, string>
---@field max_length? number
---@field mode? 0|1|2
---@field show_filename_only? boolean
---@field show_modified_status? boolean
---@field use_mode_colors? boolean
---@field windows_color? ComponentsColor

---@class LuaLine.Components.Filesize: LuaLine.Components.Spec
---@field [1] 'filesize'

---@class LuaLine.Components.Branch: LuaLine.Components.Spec
---@field [1] 'branch'

---@class LuaLine.Components.Encoding: LuaLine.Components.Spec
---@field [1] 'encoding'

---@class LuaLine.Components.Hostname: LuaLine.Components.Spec
---@field [1] 'hostname'

---@class LuaLine.Components.Mode
---@field [1] 'mode'
---@field fmt? fun(str: string): string

---@class LuaLine.Components.Progress: LuaLine.Components.Spec
---@field [1] 'progress'

---@class LuaLine.Components.Location: LuaLine.Components.Spec
---@field [1] 'location'

---@class LuaLine.Components.Selectioncount: LuaLine.Components.Spec
---@field [1] 'selectioncount'

---@alias LuaLine.Components
---|LuaLine.Components.Branch
---|LuaLine.Components.Buffers
---|LuaLine.Components.DateTime
---|LuaLine.Components.Diagnostics
---|LuaLine.Components.Diff
---|LuaLine.Components.Encoding
---|LuaLine.Components.Fileformat
---|LuaLine.Components.Filename
---|LuaLine.Components.Filesize
---|LuaLine.Components.Filetype
---|LuaLine.Components.Hostname
---|LuaLine.Components.Location
---|LuaLine.Components.Mode
---|LuaLine.Components.Progress
---|LuaLine.Components.Searchcount
---|LuaLine.Components.Selectioncount
---|LuaLine.Components.Spec
---|LuaLine.Components.Tabs
---|LuaLine.Components.Windows

---@class LuaLine.ComponentsDict
---@field branch LuaLine.Components.Branch
---@field buffers LuaLine.Components.Buffers
---@field datetime LuaLine.Components.DateTime
---@field diagnostics LuaLine.Components.Diagnostics
---@field diff LuaLine.Components.Diff
---@field encoding LuaLine.Components.Encoding
---@field fileformat LuaLine.Components.Fileformat
---@field filename LuaLine.Components.Filename
---@field filesize LuaLine.Components.Filesize
---@field filetype LuaLine.Components.Filetype
---@field hostname LuaLine.Components.Hostname
---@field location LuaLine.Components.Location
---@field mode LuaLine.Components.Mode
---@field progress LuaLine.Components.Progress
---@field project Project.LuaLineOpts
---@field searchcount LuaLine.Components.Searchcount
---@field selectioncount LuaLine.Components.Selectioncount
---@field tabs LuaLine.Components.Tabs
---@field triforce? Triforce.LualineConfig
---@field windows LuaLine.Components.Windows

---@alias LuaLineSection (LuaLine.Components|SectionComponentStr|function)[]|table

---@class LuaLine.Sections
---@field lualine_a LuaLineSection
---@field lualine_b LuaLineSection
---@field lualine_c LuaLineSection
---@field lualine_x LuaLineSection
---@field lualine_y LuaLineSection
---@field lualine_z LuaLineSection

local exists = require('user_api').check.module

---@param theme? ''|'auto'|string
---@param force_auto? boolean
---@return string
local function theme_select(theme, force_auto)
  require('user_api').check.validate({
    theme = { theme, { 'string', 'nil' } },
    force_auto = { force_auto, { 'boolean', 'nil' } },
  })
  force_auto = force_auto ~= nil and force_auto or false
  if vim.list_contains({ 'auto', '' }, theme) or force_auto then
    return 'auto'
  end

  local themes = { 'tokyonight', 'catppuccin', 'nightfox', 'onedark' }
  if not vim.list_contains(themes, theme) then
    return 'auto'
  end

  for _, t in ipairs(themes) do
    if t == theme and exists(theme) then
      return theme
    end
  end
  return 'auto'
end

return { ---@type LazySpec
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  version = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    { 'arkav/lualine-lsp-progress', version = false },
  },
  cond = not require('user_api').check.in_console(),
  config = function()
    ---@class LuaLine.Presets
    local Presets = {
      components = { ---@type LuaLine.ComponentsDict|table<string, LuaLine.Components.Spec>
        branch = { 'branch' },
        buffers = {
          'buffers',
          buffers_color = { active = 'lualine_c_normal', inactive = 'lualine_c_inactive' },
          filetype_names = {
            NvimTree = 'Nvim Tree',
            TelescopePrompt = 'Telescope',
            alpha = 'Alpha',
            dashboard = 'Dashboard',
            fzf = 'FZF',
            lazy = 'Lazy',
            packer = 'Packer',
            qf = 'Quickfix',
          },
          max_length = math.floor(vim.o.columns / 4),
          symbols = { alternate_file = '#', directory = '', modified = ' ●' },
        },
        datetime = { 'datetime', style = 'uk' },
        diagnostics = {
          'diagnostics',
          always_visible = true,
          colored = true,
          diagnostics_color = {
            error = 'DiagnosticError',
            hint = 'DiagnosticHint',
            info = 'DiagnosticInfo',
            warn = 'DiagnosticWarn',
          },
          sections = { 'error', 'warn' },
          sources = { 'nvim_workspace_diagnostic' },
          symbols = { error = '󰅚 ', hint = '󰌶 ', info = ' ', warn = '󰀪 ' },
          update_in_insert = false,
        },
        diff = {
          'diff',
          colored = true,
          diff_color = { added = 'LuaLineDiffAdd', modified = 'LuaLineDiffChange', removed = 'LuaLineDiffDelete' },
          symbols = { added = '+', modified = '~', removed = '-' },
        },
        encoding = { 'encoding' },
        fileformat = { 'fileformat', symbols = { dos = '', mac = '', unix = '' } },
        filename = { 'filename', file_status = true, newfile_status = true, path = 4 },
        filesize = { 'filesize' },
        filetype = { 'filetype', colored = false, icon = { align = 'right' }, icon_only = false },
        hostname = { 'hostname' },
        location = { 'location' },
        lsp_progress = not exists('lualine.components.lsp_progress') and nil or {
          'lsp_progress',
          colors = {
            lsp_client_name = '#c678dd',
            message = '#008080',
            percentage = '#008080',
            spinner = '#008080',
            title = '#008080',
            use = true,
          },
          display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
          separators = {
            component = ' ',
            lsp_client_name = { pre = '[', post = ']' },
            message = { pre = '(', post = ')' },
            percentage = { pre = '', post = '%% ' },
            progress = ' | ',
            spinner = { pre = '', post = '' },
            title = { pre = '', post = ': ' },
          },
          spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
          timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
        },
        mode = {
          'mode',
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
        pomo = not exists('pomo') and nil or {
          function()
            local ok, pomo = pcall(require, 'pomo')
            if not (ok and pomo) then
              return ''
            end
            local timer = pomo.get_first_to_finish()
            return not timer and ''
              or ('󰄉 %02d:%02d:%02d'):format(
                math.floor(timer:time_remaining() / 3600),
                math.floor((timer:time_remaining() % 3600) / 60),
                timer:time_remaining() % 60
              )
          end,
        },
        project = not exists('lualine.components.project') and nil
          or { 'project', enclose_pair = { '(', ')' }, format = 'short' },
        searchcount = { 'searchcount', maxcount = 999, timeout = 500 },
        selectioncount = { 'selectioncount' },
        tabs = {
          'tabs',
          mode = 2,
          path = 1,
          tab_max_length = math.floor(vim.o.columns / 3),
          tabs_color = { active = 'lualine_b_normal', inactive = 'lualine_b_inactive' },
        },
        triforce = not exists('triforce') and nil or {
          'triforce',
          achievements = { enabled = false, index = 4, show_count = true },
          level = {
            bar = { chars = { empty = '○', filled = '●' }, length = 6 },
            enabled = true,
            show = { bar = true, level = true, xp = true },
          },
          session_time = { enabled = true, format = 'long', index = 1, show_duration = true },
          streak = { show_days = false },
        },
        windows = {
          'windows',
          disabled_buftypes = { 'help', 'prompt', 'quickfix', 'terminal' },
          max_length = math.floor(vim.o.columns / 5),
          windows_color = { active = 'lualine_z_normal', inactive = 'lualine_z_inactive' },
        },
      },
    }

    Presets.default = {
      lualine_a = { Presets.components.mode },
      lualine_b = { Presets.components.project, Presets.components.filename },
      lualine_c = { Presets.components.diagnostics, Presets.components.diff },
      lualine_x = { Presets.components.triforce, Presets.components.fileformat, Presets.components.filetype },
      lualine_y = { Presets.components.progress },
      lualine_z = { Presets.components.location },
    }
    Presets.default_inactive = {
      lualine_a = {},
      lualine_b = { Presets.components.filename },
      lualine_c = {},
      lualine_x = { Presets.components.filetype },
      lualine_y = {},
      lualine_z = { Presets.components.location },
    }

    require('lualine').setup({
      extensions = { 'lazy', 'man', 'nvim-tree', 'toggleterm' },
      inactive_sections = Presets.default_inactive,
      inactive_tabline = {},
      inactive_winbar = {},
      options = {
        always_divide_middle = false,
        component_separators = { left = '', right = '' },
        globalstatus = true,
        icons_enabled = true,
        ignore_focus = {},
        refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
        section_separators = { left = '', right = '' },
        theme = theme_select('catppuccin', true),
      },
      sections = Presets.default,
    })
  end,
}
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
