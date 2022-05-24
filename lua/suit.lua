--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local open = require('suit.open').open
local init = require('suit.config').init

local M = {}

local function input(opts, on_confirm)
  -- print(vim.inspect(opts))
  open(opts, on_confirm)
end

function M.setup(config)
  vim.ui.input = input
  init(config)
end

return M
