--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local api = vim.api
local cmd = vim.cmd
local keymap = vim.keymap

local get_config = require('suit.config').get_config
local win_cfg = require('suit.config').win_config
local utils = require('suit.utils')

local function get_offset(border)
  if border == 'none' or not border then
    return 0
  end
  if type(border) == 'table' and #border[8] > 0 then
    return 1
  end
  return 0
end

local function open(opts, on_confirm)
  local config = get_config().input
  local prompt = opts.prompt or config.default_prompt
  local input_config = vim.deepcopy(win_cfg.input.input)
  local prompt_config = vim.deepcopy(win_cfg.input.prompt)
  prompt_config.width = math.max(vim.str_utfindex(prompt), 1)
  local prompt_win = utils.open_float_win(
    prompt_config,
    { prompt },
    false,
    true
  )
  input_config.col = api.nvim_win_get_width(prompt_win.window)
      + get_offset(prompt_config.border)
  local input_win = utils.open_float_win(
    input_config,
    { opts.default or nil },
    true
  )
  local cursor_col = opts.default and vim.str_utfindex(opts.default) + 1 or 0
  utils.set_hl(config, { input = input_win, prompt = prompt_win })
  cmd('startinsert')
  api.nvim_win_set_cursor(input_win.window, { 1, cursor_col })
  keymap.set({ 'n', 'i', 'v' }, '<cr>', function()
    local lines = api.nvim_buf_get_lines(input_win.buffer, 0, 1, false)
    if on_confirm then
      on_confirm(lines[1])
    end
    utils.close_windows({ input_win.window, prompt_win.window })
  end, { buffer = input_win.buffer })
  api.nvim_create_autocmd({ 'BufLeave', 'InsertLeave' }, {
    buffer = input_win.buffer,
    callback = function()
      if on_confirm then
        on_confirm(nil)
      end
      utils.close_windows({ input_win.window, prompt_win.window })
    end,
  })
end

local M = { open = open }

return M
