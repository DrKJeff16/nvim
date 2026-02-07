---@module 'user_api.maps._meta'

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }
local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local in_list = vim.list_contains

local Maps = {} ---@type User.Maps

Maps.modes = MODES
Maps.keymap = require('user_api.maps.keymap')
Maps.wk = require('user_api.maps.wk')

function Maps.desc(desc, silent, bufnr, noremap, nowait, expr)
  require('user_api.check.exists').validate({
    desc = { desc, { 'string', 'nil' }, true },
    silent = { silent, { 'boolean', 'nil' }, true },
    bufnr = { bufnr, { 'number', 'nil' }, true },
    noremap = { noremap, { 'boolean', 'nil' }, true },
    nowait = { nowait, { 'boolean', 'nil' }, true },
    expr = { expr, { 'boolean', 'nil' }, true },
  })
  desc = (desc and desc ~= '') and desc or 'Unnamed Key'
  silent = silent ~= nil and silent or true
  noremap = noremap ~= nil and noremap or true

  local res = require('user_api.maps.objects').new()
  res:add({ desc = desc, silent = silent, noremap = noremap })

  if nowait ~= nil then
    res:add({ nowait = nowait })
  end
  if expr ~= nil then
    res:add({ expr = expr })
  end
  if bufnr ~= nil then
    res:add({ buffer = bufnr })
  end
  return res
end

function Maps.nop(T, opts, mode, prefix)
  require('user_api.check.exists').validate({
    T = { T, { 'string', 'table' } },
    opts = { opts, { 'table', 'nil' }, true },
    mode = { mode, { 'string', 'nil' }, true },
    prefix = { prefix, { 'string', 'nil' }, true },
  })

  local Value = require('user_api.check.value')
  mode = (Value.is_str(mode) and in_list(MODES, mode)) and mode or 'n'

  if mode == 'i' then
    vim.notify(
      '(user_api.maps.nop): Refusing to NO-OP these keys in Insert mode: ' .. vim.inspect(T),
      WARN
    )
    return
  end

  opts = opts or {}
  opts.silent = Value.is_bool(opts.silent) and opts.silent or true
  if Value.is_int(opts.buffer) then
    opts = require('user_api.util').strip_fields(opts, 'buffer') ---@type User.Maps.Opts
  end
  prefix = prefix or ''

  local func = Maps.keymap[mode]
  if Value.is_str(T) then
    ---@cast T string
    func(prefix .. T, '<Nop>', opts)
    return
  end

  ---@cast T string[]
  for _, v in ipairs(T) do
    func(prefix .. v, '<Nop>', opts)
  end
end

function Maps.map_dict(T, map_func, has_modes, mode, bufnr)
  require('user_api.check.exists').validate({
    T = { T, { 'table' } },
    map_func = { map_func, { 'string' } },
    has_modes = { has_modes, { 'boolean', 'nil' }, true },
    mode = { mode, { 'string', 'table', 'nil' }, true },
    bufnr = { bufnr, { 'number', 'nil' }, true },
  })

  local Value = require('user_api.check.value')
  if not Value.type_not_empty('table', T) then
    error("(user_api.maps.map_dict): Keys either aren't table or table is empty", ERROR)
  end

  local map_choices = { 'keymap', 'wk.register' }
  map_func = in_list(map_choices, map_func) and map_func or 'wk.register'
  if not Maps.wk.available() then
    map_func = 'keymap'
  end
  mode = (Value.is_str(mode) and in_list(MODES, mode)) and mode or 'n'
  has_modes = Value.is_bool(has_modes) and has_modes or false
  bufnr = Value.is_int(bufnr) and bufnr or nil

  local func
  if has_modes then
    local keymap_ran = false
    ---@cast T AllModeMaps
    for mode_choice, t in pairs(T) do
      if in_list(MODES, mode_choice) then
        if map_func == 'keymap' then
          func = Maps.keymap[mode_choice]
          for lhs, v in pairs(t) do
            if v[2] and v[3] then
              func(lhs, v[2], v[3] or {})
            elseif v[1] then
              func(lhs, v[1], v[2] or {})
            end
          end
          keymap_ran = true
        end

        for lhs, v in pairs(t) do
          if keymap_ran then
            break
          end
          if Value.is_str(lhs) then
            local tbl = {}
            table.insert(tbl, lhs)
            if v[1] ~= nil then
              table.insert(tbl, v[1])
            end

            tbl.mode = mode_choice

            if bufnr ~= nil then
              tbl.buffer = bufnr
            end
            if Value.is_str(v.proxy) then
              tbl.proxy = v.proxy
            end
            if Value.is_str(v.group) then
              tbl.group = v.group
            end
            if Value.is_bool(v.hidden) then
              tbl.hidden = v.hidden
            end
            if not Value.is_tbl(v[2]) then
              v[2] = {}
            end
            if Value.is_str(v[2].desc) then
              tbl.desc = v[2].desc
            end
            if Value.is_bool(v[2].expr) then
              tbl.expr = v[2].expr
            end
            if Value.is_bool(v[2].noremap) then
              tbl.noremap = v[2].noremap
            end
            if Value.is_bool(v[2].nowait) then
              tbl.nowait = v[2].nowait
            end
            if Value.is_bool(v[2].silent) then
              tbl.silent = v[2].silent
            end

            require('which-key').add(tbl)
          end
        end
      end
    end
    return
  end

  if map_func == 'keymap' then
    func = Maps.keymap[mode]
    ---@cast T AllMaps
    for lhs, v in pairs(T) do
      if v[2] and v[3] then
        func(lhs, v[2], v[3])
      elseif v[1] then
        func(lhs, v[1], v[2] or {})
      end
    end
    return
  end

  ---@cast T AllMaps
  for lhs, v in pairs(T) do
    local tbl = {}
    if Value.is_str(lhs) then
      table.insert(tbl, lhs)
      if v[1] ~= nil then
        table.insert(tbl, v[1])
      end

      tbl.mode = mode

      if bufnr ~= nil then
        tbl.buffer = bufnr
      end
      if Value.is_str(v.proxy) then
        tbl.proxy = v.proxy
      end
      if Value.is_str(v.group) then
        tbl.group = v.group
      end
      if Value.is_bool(v.hidden) then
        tbl.hidden = v.hidden
      end

      if Value.is_tbl(v[2]) then
        if Value.is_str(v[2].desc) then
          tbl.desc = v[2].desc
        end
        if Value.is_bool(v[2].expr) then
          tbl.expr = v[2].expr
        end
        if Value.is_bool(v[2].noremap) then
          tbl.noremap = v[2].noremap
        end
        if Value.is_bool(v[2].nowait) then
          tbl.nowait = v[2].nowait
        end
        if Value.is_bool(v[2].silent) then
          tbl.silent = v[2].silent
        end
      end

      require('which-key').add(tbl)
    end
  end
end

local M = setmetatable(Maps, { ---@type User.Maps
  __index = Maps,
  __newindex = function()
    vim.notify('User.Maps is Read-Only!', ERROR)
  end,
})

return M
-- vim: set ts=2 sts=2 sw=2 et ai si sta:
