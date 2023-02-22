-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local input_open = require('suit.input').open
local select_open = require('suit.select').open
local init_config = require('suit.config').init
local hl_exists = require('dmap.utils').hl_exists

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

local function init_hl(config)
  local input_default_hls = {
    hl_win = 'NormalFloat',
    hl_prompt = 'NormalFloat',
    hl_border = 'FloatBorder',
  }
  local select_default_hls = {
    hl_win = 'NormalFloat',
    hl_prompt = 'NormalFloat',
    hl_sel = 'PmenuSel',
    hl_border = 'FloatBorder',
  }
  local set_hls = function(inner_cfg, t)
    for k_hl, default in pairs(t) do
      local hl = inner_cfg[k_hl]
      if not hl_exists(hl) then
        vim.api.nvim_set_hl(0, hl, { link = default })
      end
    end
  end

  set_hls(config.input, input_default_hls)
  set_hls(config.select, select_default_hls)
end

function M.setup(config)
  vim.ui.input = input
  vim.ui.select = select
  local _config = init_config(config)
  init_hl(_config)
end

return M
