--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local api = vim.api
local cmd = vim.cmd

local function win_hl_override(window, hl_group, value)
  local new_value = string.format('%s:%s', hl_group, value)
  local opt = api.nvim_win_get_option(window, 'winhighlight')
  if #opt > 0 then
    new_value = string.format('%s,%s', opt, new_value)
  end
  api.nvim_win_set_option(window, 'winhighlight', new_value)
end

local function set_hl(config, windows)
  for k, win in pairs(windows) do
    api.nvim_buf_add_highlight(
      win.buffer,
      0,
      config[string.format('hl_%s_win', k)],
      0,
      0,
      -1
    )
    win_hl_override(
      win.window,
      'NormalFloat',
      config[string.format('hl_%s_win', k)]
    )
    win_hl_override(
      win.window,
      'FloatBorder',
      config[string.format('hl_%s_border', k)]
    )
  end
end

local function open_float_win(config, lines, enter, lock)
  local buffer = api.nvim_create_buf(false, true)
  local window = api.nvim_open_win(buffer, enter, config)
  -- nvim_buf_set_lines creates an empty line at the end, due to
  -- that use nvim_buf_set_text to write the last line item
  if #lines == 1 then
    api.nvim_buf_set_text(buffer, 0, 0, 0, 0, lines)
  else
    local copy = vim.deepcopy(lines)
    local last = table.remove(copy)
    api.nvim_buf_set_lines(buffer, 0, 0, nil, copy)
    api.nvim_buf_set_text(buffer, #copy, 0, #copy, 0, { last })
  end
  if lock then
    api.nvim_buf_set_option(buffer, 'modifiable', false)
  end
  return { buffer = buffer, window = window }
end

local function close_windows(windows)
  for _, win in ipairs(windows) do
    if api.nvim_win_is_valid(win) then
      api.nvim_win_close(win, true)
    end
  end
  cmd('stopinsert')
end

local M = {
  win_hl_override = win_hl_override,
  set_hl = set_hl,
  open_float_win = open_float_win,
  close_windows = close_windows,
}
return M
