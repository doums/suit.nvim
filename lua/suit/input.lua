-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local get_config = require('suit.config').get_config
local util = require('suit.util')

local function open(opts, on_confirm)
  local config = get_config().input
  local prompt = opts.prompt or config.default_prompt
  local win_config = vim.deepcopy(config.win_config)
  local default_value_width = opts.default
      and vim.str_utfindex(opts.default, 'utf-16')
    or 0
  local input_width = win_config.width + default_value_width
  local prompt_width = vim.str_utfindex(prompt, 'utf-16')
  local width = input_width > prompt_width and input_width or prompt_width
  win_config.width = util.clamp(width, config.max_width or 50)
  win_config.title = { { prompt, 'suitPrompt' } }
  local win = util.open_float_win(win_config, { opts.default or nil })
  local cursor_col = opts.default and default_value_width + 1 or 0
  vim.cmd('startinsert')
  vim.api.nvim_win_set_cursor(win.window, { 1, cursor_col })
  local confirmed = false
  vim.keymap.set({ 'n', 'i', 'v' }, '<cr>', function()
    local lines = vim.api.nvim_buf_get_lines(win.buffer, 0, 1, false)
    if on_confirm then
      confirmed = true
      on_confirm(lines[1])
      return
    end
    util.close_window(win.window)
  end, { buffer = win.buffer })
  vim.api.nvim_create_autocmd({ 'BufLeave', 'InsertLeave' }, {
    buffer = win.buffer,
    callback = function()
      if on_confirm and not confirmed then
        on_confirm(nil)
      end
      util.close_window(win.window)
    end,
  })
end

local M = { open = open }

return M
