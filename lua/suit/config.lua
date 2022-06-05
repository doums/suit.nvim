--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

-- default configuration
local _config = {
  input = {
    -- default prompt value
    default_prompt = 'Input: ',
    -- highlight group to use for input window
    hl_input_win = 'NormalFloat',
    -- highlight group to use for input border
    hl_input_border = 'FloatBorder',
    -- highlight group to use for prompt window
    hl_prompt_win = 'NormalFloat',
    -- highlight group to use for prompt border
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
  },
  select = {
    -- default prompt value
    default_prompt = 'Select one of: ',
    -- highlight group to use for select window
    hl_select_win = 'NormalFloat',
    -- highlight group to use for select border
    hl_select_border = 'FloatBorder',
    -- highlight group to use for prompt window
    hl_prompt_win = 'NormalFloat',
    -- highlight group to use for prompt border
    hl_prompt_border = 'FloatBorder',
    -- Options passed to nvim_open_win (:h nvim_open_win())
    -- You can use it to customize various things like border etc.
    select_win = {
      style = 'minimal',
      relative = 'cursor',
      width = 25,
      height = 1,
      zindex = 200,
      row = 1,
      col = 0,
      border = { '', '', '', ' ', '', '', '', '' },
    },
    prompt_win = {
      style = 'minimal',
      relative = 'cursor',
      width = 25,
      height = 1,
      zindex = 200,
      row = 1,
      col = 0,
      border = { '', '', '', '', '', '', '', ' ' },
      focusable = false,
    },
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
