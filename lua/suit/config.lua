--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local border_factory = require('suit.border').factory

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
    -- input width (in addition to the default value)
    width = 20,
    -- override arguments passed to `nvim_open_win` (see `:h nvim_open_win`)
    nvim_float_api = nil,
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
    -- override arguments passed to `nvim_open_win` (see `:h nvim_open_win`)
    nvim_float_api = nil,
  },
}

local win_config = {
  input = {
    style = 'minimal',
    border = 'none',
    relative = 'cursor',
    width = 20,
    height = 2,
    zindex = 200,
    row = 1,
    col = 0,
  },
  select = {
    style = 'minimal',
    border = 'none',
    relative = 'cursor',
    width = 25,
    height = 1,
    zindex = 200,
    row = 1,
    col = 0,
  },
}

local function init(config)
  if config then
    _config = vim.tbl_deep_extend('force', _config, config)
  end
  win_config.input.border = border_factory(_config.input.border)
  win_config.select.border = border_factory(_config.select.border)
  if config.input.nvim_float_api then
    win_config.input = vim.tbl_deep_extend(
      'force',
      win_config.input,
      config.input.nvim_float_api
    )
  end
  if config.select.nvim_float_api then
    win_config.select = vim.tbl_deep_extend(
      'force',
      win_config.select,
      config.select.nvim_float_api
    )
  end
end

local function get_config()
  return _config
end

local M = { get_config = get_config, init = init, win_config = win_config }
return M
