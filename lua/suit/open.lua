--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local api = vim.api
local cmd = vim.cmd
local opt = vim.opt
local keymap = vim.keymap

local _config = require('suit.config').config

local function set_hl(config)
  if config.bg_color then
    -- TODO use api.nvim_set_hl instead
    cmd('hi! floatermWin guibg=' .. config.bg_color)
    opt.winhighlight:prepend('NormalFloat:floatermWin,')
  end
  if config.border_hl then
    opt.winhighlight:prepend(string.format('FloatBorder:%s,', config.border_hl))
  end
end

local function open_float_win(config, enter)
  local buffer = api.nvim_create_buf(false, true)
  local window = api.nvim_open_win(buffer, enter, config)
  return { buffer = buffer, window = window }
end

local function on_close(input_win, prompt_win)
  api.nvim_win_close(input_win, true)
  api.nvim_win_close(prompt_win, true)
  cmd('stopinsert')
end

local function open(opts, on_confirm)
  local prompt = opts.prompt or _config.default_prompt
  local input_config = vim.deepcopy(_config.input_win)
  local prompt_config = vim.deepcopy(_config.prompt_win)
  prompt_config.width = vim.str_utfindex(prompt)
  local prompt_win = open_float_win(prompt_config, false)
  input_config.col = api.nvim_win_get_width(prompt_win.window) + 1
  local input_win = open_float_win(input_config, true)
  api.nvim_buf_set_lines(prompt_win.buffer, 0, 1, nil, { prompt })
  local cursor_col = 0
  if opts.default then
    api.nvim_buf_set_lines(input_win.buffer, 0, 1, nil, { opts.default })
    cursor_col = #opts.default + 1
  end
  cmd('startinsert')
  api.nvim_win_set_cursor(input_win.window, { 1, cursor_col })
  keymap.set({ 'n', 'i', 'v' }, '<cr>', function()
    local lines = api.nvim_buf_get_lines(input_win.buffer, 0, 1, false)
    on_confirm(lines[1])
    on_close(input_win.window, prompt_win.window)
  end, { buffer = input_win.buffer })
  keymap.set({ 'n', 'i', 'v' }, '<esc>', function()
    on_confirm(nil)
    on_close(input_win.window, prompt_win.window)
  end, { buffer = input_win.buffer })
  api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    buffer = input_win.buffer,
    callback = function(arg)
      on_confirm(nil)
      on_close(input_win.window, prompt_win.window)
    end,
  })
end

local M = { open = open }

return M
