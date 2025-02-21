-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local api = vim.api

local get_config = require('suit.config').get_config
local utils = require('suit.utils')

local function get_max_width(items, prompt)
  local width = vim.str_utfindex(prompt)
  for _, item in ipairs(items) do
    local len = vim.str_utfindex(item)
    if len > width then
      width = len
    end
  end
  return width
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
      local len = vim.str_utfindex(item)
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
  win_config.width = width
  win_config.height = #items + 1
  local prev_mode = api.nvim_get_mode().mode
  local select_win = utils.open_float_win(win_config, items, true)
  vim.wo.winbar = string.format('%%#%s#%s', config.hl_prompt, prompt)
  vim.wo.scrolloff = 0
  utils.set_hl(api.nvim_create_namespace(''), config, select_win)
  -- overriding Cursor highlight group seems forbidden and throws
  -- an error
  -- utils.win_hl_override(select_win.window, 'Cursor', config.hl_selected_item)
  api.nvim_win_set_cursor(select_win.window, { 1, 0 })
  vim.keymap.set({ 'n', 'v' }, '<up>', '<up>', { buffer = select_win.buffer })
  vim.keymap.set(
    { 'n', 'v' },
    '<down>',
    '<down>',
    { buffer = select_win.buffer }
  )
  local function on_item_select()
    if on_choice then
      local row = unpack(api.nvim_win_get_cursor(select_win.window))
      -- restore previous mode and selection
      if utils.is_visual(prev_mode) then
        api.nvim_feedkeys('gv', 'n', false)
      end
      utils.close_window(select_win.window)
      on_choice(raw_items[row], row)
    else
      utils.close_window(select_win.window)
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
    utils.close_window(select_win.window)
  end, { buffer = select_win.buffer })
  vim.keymap.set({ 'n', 'v' }, 'q', function()
    if on_choice then
      on_choice(nil, nil)
    end
    utils.close_window(select_win.window)
  end, { buffer = select_win.buffer })
  api.nvim_create_autocmd({ 'BufLeave' }, {
    buffer = select_win.buffer,
    callback = function()
      if on_choice then
        on_choice(nil, nil)
      end
      utils.close_window(select_win.window)
    end,
  })
  local ns_id = api.nvim_create_namespace('')
  api.nvim_create_autocmd({ 'CursorMoved' }, {
    buffer = select_win.buffer,
    callback = function()
      api.nvim_buf_clear_namespace(select_win.buffer, ns_id, 0, -1)
      local row = unpack(api.nvim_win_get_cursor(select_win.window)) - 1
      vim.hl.range(
        select_win.buffer,
        ns_id,
        config.hl_sel,
        { row, 0 },
        { row, -1 }
      )
    end,
  })
end

local M = { open = open }

return M
