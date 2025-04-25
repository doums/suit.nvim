-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local input_open = require('suit.input').open
local select_open = require('suit.select').open
local init_config = require('suit.config').init
local init_hl = require('suit.hl').init

local M = {}

local function input(opts, on_confirm)
  input_open(opts or {}, on_confirm)
end

local function select(items, opts, on_choice)
  if not items or #items == 0 then
    return
  end
  select_open(items, opts or {}, on_choice)
end


function M.setup(config)
  vim.ui.input = input
  vim.ui.select = select
  init_config(config)
  init_hl()
end

return M
