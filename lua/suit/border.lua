--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local map = {
  none = 'none',
  single = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  double = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' },
  rounded = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  thick = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' },
  solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  vgap = { '', '', '', ' ', '', '', '', ' ' },
  threedots = { '┌', '┄', '┐', '┊', '┘', '┄', '└', '┊' },
}

local function factory(border)
  if type(border) == 'string' then
    return map[border]
  end
  if vim.tbl_islist(border) then
    return border
  end
  return 'none'
end

local M = { factory = factory }
return M
