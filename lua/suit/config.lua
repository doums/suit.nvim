--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

-- default configuration
local _config = {
  default_prompt = '→ ',
  highlight = {
    input = {
      window = 'Constant',
      border = 'FloatBorder',
    },
    prompt = {
      window = 'Constant',
      border = 'FloatBorder',
    },
  },
  -- Options passed to nvim_open_win (:h nvim_open_win())
  -- You can use it to customize various things like border etc.
  input_win = {
    style = 'minimal',
    relative = 'cursor',
    width = 30,
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
  -- Some mapping, exit: close the job and the window, normal:
  -- switch to normal mode
  keymaps = { cancel = '<A-q>', normal = '<A-n>' },
}

local function init(config)
  if config then
    _config = vim.tbl_deep_extend('force', _config, config)
  end
end

local M = { config = _config }
return M
