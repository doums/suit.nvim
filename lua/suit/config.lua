-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local M = {}

-- default configuration
local _config = {
  input = {
    -- default prompt value
    default_prompt = 'Input: ',
    -- border of the window (see `:h nvim_open_win`)
    border = 'single',
    -- highlight group for the input UI window
    -- links to NormalFloat
    hl_win = 'suitWin',
    -- highlight group for the prompt text
    -- links to NormalFloat
    hl_prompt = 'suitPrompt',
    -- highlight group for the window border
    -- links to FloatBorder
    hl_border = 'suitBorder',
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
    -- highlight group for the select UI window
    -- links to NormalFloat
    hl_win = 'suitWin',
    -- highlight group for the prompt text
    -- links to NormalFloat
    hl_prompt = 'suitPrompt',
    -- highlight group for the selected item
    -- links to PmenuSel
    hl_sel = 'suitSel',
    -- highlight group for the window border
    -- links to FloatBorder
    hl_border = 'suitBorder',
    -- override arguments passed to `nvim_open_win` (see `:h nvim_open_win`)
    nvim_float_api = nil,
  },
}

local _win_config_input = {
  style = 'minimal',
  border = 'none',
  relative = 'cursor',
  width = 20,
  height = 2,
  zindex = 200,
  row = 1,
  col = 0,
}

local _win_config_select = {
  style = 'minimal',
  border = 'none',
  relative = 'cursor',
  width = 25,
  height = 1,
  zindex = 200,
  row = 1,
  col = 0,
}

function M.init(config)
  _config = vim.tbl_deep_extend('force', _config, config or {})

  _win_config_input.border = _config.input.border
  _win_config_select.border = _config.select.border

  if _config.input.nvim_float_api then
    _win_config_input = vim.tbl_deep_extend(
      'force',
      _win_config_input,
      _config.input.nvim_float_api
    )
  end
  if _config.select.nvim_float_api then
    _win_config_select = vim.tbl_deep_extend(
      'force',
      _win_config_select,
      _config.select.nvim_float_api
    )
  end

  _config.input.win_config = _win_config_input
  _config.select.win_config = _win_config_select
  return _config
end

function M.get_config()
  return _config
end

return M
