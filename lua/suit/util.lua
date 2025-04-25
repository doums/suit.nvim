-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local M = {}

local set_win_hl = require('suit.hl').set_win_hl

function M.open_float_win(config, lines, lock)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, config)
  set_win_hl(win)
  -- nvim_buf_set_lines creates an empty line at the end, due to
  -- that use nvim_buf_set_text to write the last line item
  if #lines == 1 then
    vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, lines)
  else
    local copy = vim.deepcopy(lines)
    local last = table.remove(copy)
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, copy)
    vim.api.nvim_buf_set_text(buf, #copy, 0, #copy, 0, { last })
  end
  if lock then
    vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  end
  vim.api.nvim_set_option_value('filetype', 'suitui', { buf = buf })
  vim.wo[win].wrap = false
  return { buffer = buf, window = win }
end

function M.close_window(win)
  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  vim.cmd('stopinsert')
end

function M.is_visual(mode)
  local visual_modes = { 'v', 'V', '\22' }
  return vim.tbl_contains(visual_modes, mode)
end

function M.clamp(val, max)
  if val > max then
    return max
  end
  return val
end

return M
