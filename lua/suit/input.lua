--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local api = vim.api
local cmd = vim.cmd
local keymap = vim.keymap

local get_config = require('suit.config').get_config
local win_cfg = require('suit.config').win_config
local utils = require('suit.utils')

local function open(opts, on_confirm)
  local config = get_config().input
  local prompt = opts.prompt or config.default_prompt
  local input_config = vim.deepcopy(win_cfg.input)
  local default_value_width = opts.default and vim.str_utfindex(opts.default) or 0
  local input_width = input_config.width + default_value_width
  local prompt_width = vim.str_utfindex(prompt)
  input_config.width = input_width > prompt_width and input_width
    or prompt_width
  local input_win = utils.open_float_win(input_config, { opts.default or nil })
  vim.wo.winbar = string.format('%%#%s#%s', config.hl_prompt, prompt)
  local cursor_col = opts.default and default_value_width + 1 or 0
  utils.set_hl(config, input_win, 'input')
  cmd('startinsert')
  api.nvim_win_set_cursor(input_win.window, { 1, cursor_col })
  keymap.set({ 'n', 'i', 'v' }, '<cr>', function()
    local lines = api.nvim_buf_get_lines(input_win.buffer, 0, 1, false)
    if on_confirm then
      on_confirm(lines[1])
    end
    utils.close_window(input_win.window)
  end, { buffer = input_win.buffer })
  api.nvim_create_autocmd({ 'BufLeave', 'InsertLeave' }, {
    buffer = input_win.buffer,
    callback = function()
      if on_confirm then
        on_confirm(nil)
      end
      utils.close_window(input_win.window)
    end,
  })
end

local M = { open = open }

return M
