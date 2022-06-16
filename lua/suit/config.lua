--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local create_border = require('suit.layout').create_border

-- default configuration
local _config = {
  input = {
    -- default prompt value
    default_prompt = 'Input: ',
    -- border of the window (see `:h nvim_open_win`)
    border = 'single',
    -- highlight group for input
    hl_input = 'NormalFloat',
    -- highlight group for prompt
    hl_prompt = 'NormalFloat',
    -- highlight group for window border
    hl_border = 'FloatBorder',
  },
  select = {
    -- default prompt value
    default_prompt = 'Select one of: ',
    -- border of the window (see `:h nvim_open_win`)
    border = 'single',
    -- highlight group for select list
    hl_select = 'NormalFloat',
    -- highlight group for prompt
    hl_prompt = 'NormalFloat',
    -- highlight group for current selected item
    hl_selected_item = 'PmenuSel',
    -- highlight group for window border
    hl_border = 'FloatBorder',
  },
}

local win_config = {
  input = {
    input = {
      style = 'minimal',
      border = 'none',
      relative = 'cursor',
      width = 20,
      height = 1,
      zindex = 200,
      row = 1,
      col = 0,
    },
    prompt = {
      style = 'minimal',
      border = 'none',
      relative = 'cursor',
      height = 1,
      zindex = 200,
      row = 1,
      col = 0,
      focusable = false,
    },
  },
  select = {
    select = {
      style = 'minimal',
      border = 'none',
      relative = 'cursor',
      width = 25,
      height = 1,
      zindex = 200,
      row = 2,
      col = 0,
    },
    prompt = {
      style = 'minimal',
      border = 'none',
      relative = 'cursor',
      width = 25,
      height = 1,
      zindex = 200,
      row = 1,
      col = 0,
      focusable = false,
    },
  },
}

local function init(config)
  if config then
    _config = vim.tbl_deep_extend('force', _config, config)
  end
  local input_borders = create_border('row', _config.input.border)
  local select_borders = create_border('column', _config.select.border)
  win_config.input.prompt.border = input_borders[1]
  win_config.input.input.border = input_borders[2]
  win_config.select.prompt.border = select_borders[1]
  win_config.select.select.border = select_borders[2]
end

local function get_config()
  return _config
end

local M = { get_config = get_config, init = init, win_config = win_config }
return M
