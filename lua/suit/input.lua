-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local api = vim.api

local get_config = require('suit.config').get_config
local utils = require('suit.utils')

local function open(opts, on_confirm)
  local config = get_config().input
  local prompt = opts.prompt or config.default_prompt
  local win_config = vim.deepcopy(config.win_config)
  local default_value_width = opts.default and vim.str_utfindex(opts.default)
    or 0
  local input_width = win_config.width + default_value_width
  local prompt_width = vim.str_utfindex(prompt)
  win_config.width = input_width > prompt_width and input_width or prompt_width
  win_config.title = { { prompt, 'suitPrompt' } }
  local win = utils.open_float_win(win_config, { opts.default or nil })
  local cursor_col = opts.default and default_value_width + 1 or 0
  utils.set_hl(api.nvim_create_namespace(''), config, win)
  vim.cmd('startinsert')
  api.nvim_win_set_cursor(win.window, { 1, cursor_col })
  local confirmed = false
  vim.keymap.set({ 'n', 'i', 'v' }, '<cr>', function()
    local lines = api.nvim_buf_get_lines(win.buffer, 0, 1, false)
    if on_confirm then
      confirmed = true
      on_confirm(lines[1])
      return
    end
    utils.close_window(win.window)
  end, { buffer = win.buffer })
  api.nvim_create_autocmd({ 'BufLeave', 'InsertLeave' }, {
    buffer = win.buffer,
    callback = function()
      if on_confirm and not confirmed then
        on_confirm(nil)
      end
      utils.close_window(win.window)
    end,
  })
end

local M = { open = open }

return M
