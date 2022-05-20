--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local cmd = vim.cmd
local fn = vim.fn
local api = vim.api
local g = vim.g
local uv = vim.loop
local o = vim.opt

local open = require('suit.open').open

local M = {}

local function input(opts, on_confirm)
  open(opts, on_confirm)
end

function M.setup()
  vim.ui.input = input
end

return M
