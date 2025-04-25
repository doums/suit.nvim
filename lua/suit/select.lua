-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local get_config = require('suit.config').get_config
local hl = require('suit.hl').hl
local util = require('suit.util')

local function get_max_width(items, prompt)
  return vim
    .iter(items)
    :fold(vim.str_utfindex(prompt, 'utf-16'), function(acc, v)
      local len = vim.str_utfindex(v, 'utf-16')
      if len > acc then
        return len
      end
      return acc
    end)
end

local function format_items(items, format_fn, prompt)
  local formatted = vim.tbl_map(function(item)
    if format_fn then
      return format_fn(item)
    end
    return type(item) == 'string' and item or tostring(item)
  end, items)
  local max_width = get_max_width(formatted, prompt)
  return {
    vim.tbl_map(function(item)
      local len = vim.str_utfindex(item, 'utf-16')
      if len < max_width then
        local str = { item }
        for _ = 1, max_width - len do
          table.insert(str, ' ')
        end
        return table.concat(str)
      end
      return item
    end, formatted),
    max_width,
  }
end

local function open(raw_items, opts, on_choice)
  local config = get_config().select
  local prompt = opts.prompt or config.default_prompt
  local win_config = vim.deepcopy(config.win_config)
  local items, width = unpack(format_items(raw_items, opts.format_item, prompt))
  win_config.width = util.clamp(width, config.max_width or 50)
  win_config.height = #items
  win_config.title = { { prompt, 'suitPrompt' } }
  local prev_mode = vim.api.nvim_get_mode().mode
  local select_win = util.open_float_win(win_config, items, true)
  vim.wo.scrolloff = 0
  vim.api.nvim_win_set_cursor(select_win.window, { 1, 0 })
  vim.keymap.set({ 'n', 'v' }, '<up>', '<up>', { buffer = select_win.buffer })
  vim.keymap.set(
    { 'n', 'v' },
    '<down>',
    '<down>',
    { buffer = select_win.buffer }
  )
  local function on_item_select()
    if on_choice then
      local row = unpack(vim.api.nvim_win_get_cursor(select_win.window))
      -- restore previous mode and selection
      if util.is_visual(prev_mode) then
        vim.api.nvim_feedkeys('gv', 'n', false)
      end
      util.close_window(select_win.window)
      on_choice(raw_items[row], row)
    else
      util.close_window(select_win.window)
    end
  end
  vim.keymap.set(
    { 'n', 'v' },
    '<cr>',
    on_item_select,
    { buffer = select_win.buffer }
  )
  vim.keymap.set(
    { 'n', 'v' },
    '<2-LeftMouse>',
    on_item_select,
    { buffer = select_win.buffer }
  )
  vim.keymap.set({ 'n', 'v' }, '<esc>', function()
    if on_choice then
      on_choice(nil, nil)
    end
    util.close_window(select_win.window)
  end, { buffer = select_win.buffer })
  vim.keymap.set({ 'n', 'v' }, 'q', function()
    if on_choice then
      on_choice(nil, nil)
    end
    util.close_window(select_win.window)
  end, { buffer = select_win.buffer })
  vim.api.nvim_create_autocmd({ 'BufLeave' }, {
    buffer = select_win.buffer,
    callback = function()
      if on_choice then
        on_choice(nil, nil)
      end
      util.close_window(select_win.window)
    end,
  })
  local ns_id = vim.api.nvim_create_namespace('')
  vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    buffer = select_win.buffer,
    callback = function()
      vim.api.nvim_buf_clear_namespace(select_win.buffer, ns_id, 0, -1)
      vim.hl.range(
        select_win.buffer,
        ns_id,
        hl.selected,
        '.',
        '.',
        { regtype = 'V', inclusive = true }
      )
    end,
  })
end

local M = { open = open }

return M
