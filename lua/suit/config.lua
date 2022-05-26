--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

-- default configuration
local _config = {
  default_prompt = '→ ',
  hl_input_win = 'NormalFloat',
  hl_input_border = 'FloatBorder',
  hl_prompt_win = 'NormalFloat',
  hl_prompt_border = 'FloatBorder',
  -- Options passed to nvim_open_win (:h nvim_open_win())
  -- You can use it to customize various things like border etc.
  input_win = {
    style = 'minimal',
    relative = 'cursor',
    width = 20,
    height = 1,
    zindex = 200,
    row = 1,
    col = 0,
    border = { '', '', '', ' ', '', '', '', '' },
  },
  prompt_win = {
    style = 'minimal',
    relative = 'cursor',
    height = 1,
    zindex = 200,
    row = 1,
    col = 0,
    border = { '', '', '', '', '', '', '', ' ' },
    focusable = false,
  },
}

local function init(config)
  if config then
    _config = vim.tbl_deep_extend('force', _config, config)
  end
end

local function get_config()
  return _config
end

local M = { get_config = get_config, init = init }
return M
