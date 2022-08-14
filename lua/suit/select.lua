--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local api = vim.api
local keymap = vim.keymap

local get_config = require('suit.config').get_config
local win_cfg = require('suit.config').win_config
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
        for i = 1, max_width - len do
          table.insert(str, ' ')
        end
        return table.concat(str)
      end
      return item
    end, formatted),
    max_width,
  }
end

local function get_offset(border)
  if border == 'none' or not border then
    return 0
  end
  if type(border) == 'table' and #border[1] > 0 then
    return 1
  end
  return 0
end

local function open(raw_items, opts, on_choice)
  local config = get_config().select
  local prompt = opts.prompt or config.default_prompt
  local select_config = vim.deepcopy(win_cfg.select.select)
  local prompt_config = vim.deepcopy(win_cfg.select.prompt)
  local items, width = unpack(format_items(raw_items, opts.format_item, prompt))
  select_config.width = width
  select_config.height = #items
  select_config.row = 2 + get_offset(prompt_config.border)
  prompt_config.width = width
  local prompt_win =
  utils.open_float_win(prompt_config, { prompt }, false, true)
  local select_win = utils.open_float_win(select_config, items, true, true)
  api.nvim_win_set_option(select_win.window, 'scrolloff', 0)
  utils.set_hl(config, { select = select_win, prompt = prompt_win })
  -- overriding Cursor highlight group seems forbidden and throws
  -- an error
  -- utils.win_hl_override(select_win.window, 'Cursor', config.hl_selected_item)
  api.nvim_win_set_cursor(select_win.window, { 1, 0 })
  keymap.set({ 'n', 'v' }, '<up>', '<up>', { buffer = select_win.buffer })
  keymap.set({ 'n', 'v' }, '<down>', '<down>', { buffer = select_win.buffer })
  keymap.set({ 'n', 'v' }, '<cr>', function()
    if on_choice then
      local row = unpack(api.nvim_win_get_cursor(select_win.window))
      utils.close_windows({ select_win.window, prompt_win.window })
      on_choice(raw_items[row], row)
    else
      utils.close_windows({ select_win.window, prompt_win.window })
    end
  end, { buffer = select_win.buffer })
  keymap.set({ 'n', 'v' }, '<esc>', function()
    if on_choice then
      on_choice(nil, nil)
    end
    utils.close_windows({ select_win.window, prompt_win.window })
  end, { buffer = select_win.buffer })
  keymap.set({ 'n', 'v' }, 'q', function()
    if on_choice then
      on_choice(nil, nil)
    end
    utils.close_windows({ select_win.window, prompt_win.window })
  end, { buffer = select_win.buffer })
  api.nvim_create_autocmd({ 'BufLeave' }, {
    buffer = select_win.buffer,
    callback = function()
      if on_choice then
        on_choice(nil, nil)
      end
      utils.close_windows({ select_win.window, prompt_win.window })
    end,
  })
  local ns_id = api.nvim_create_namespace('')
  api.nvim_create_autocmd({ 'CursorMoved' }, {
    buffer = select_win.buffer,
    callback = function()
      api.nvim_buf_clear_namespace(select_win.buffer, ns_id, 0, -1)
      local row = unpack(api.nvim_win_get_cursor(select_win.window)) - 1
      api.nvim_buf_add_highlight(
        select_win.buffer,
        ns_id,
        config.hl_selected_item,
        row,
        0,
        -1
      )
    end,
  })
end

local M = { open = open }

return M
