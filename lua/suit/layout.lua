--[[ This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local row_map = {
  none = { 'none', 'none' },
  single = {
    { '┌', '─', '─', '', '─', '─', '└', '│' },
    { '─', '─', '┐', '│', '┘', '─', '─', '' },
  },
  double = {
    { '╔', '═', '═', '', '═', '═', '╚', '║' },
    { '═', '═', '╗', '║', '╝', '═', '═', '' },
  },
  rounded = {
    { '╭', '─', '─', '', '─', '─', '╰', '│' },
    { '─', '─', '╮', '│', '╯', '─', '─', '' },
  },
  solid = {
    { ' ', ' ', ' ', '', ' ', ' ', ' ', ' ' },
    { ' ', ' ', ' ', ' ', ' ', ' ', ' ', '' },
  },
  vgap = {
    { '', '', '', '', '', '', '', ' ' },
    { '', '', '', ' ', '', '', '', '' },
  },
}

local column_map = {
  none = { 'none', 'none' },
  single = {
    { '┌', '─', '┐', '│', '', '', '', '│' },
    { '', '', '', '│', '┘', '─', '└', '│' },
  },
  double = {
    { '╔', '═', '╗', '║', '', '', '', '║' },
    { '', '', '', '║', '╝', '═', '╚', '║' },
  },
  rounded = {
    { '╭', '─', '╮', '│', '', '', '', '│' },
    { '', '', '', '│', '╯', '─', '╰', '│' },
  },
  solid = {
    { ' ', ' ', ' ', ' ', '', '', '', ' ' },
    { '', '', '', ' ', ' ', ' ', ' ', ' ' },
  },
  vgap = {
    { '', '', '', ' ', '', '', '', ' ' },
    { '', '', '', ' ', '', '', '', ' ' },
  },
}

local function create_border(layout, border)
  if not border then
    return {}
  end
  if layout == 'row' then
    if type(border) == 'string' then
      return row_map[border]
    end
    if vim.tbl_islist(border) then
      return {
        {
          border[1],
          border[2],
          border[2],
          '',
          border[6],
          border[6],
          border[7],
          border[8],
        },
        {
          border[2],
          border[2],
          border[3],
          border[4],
          border[5],
          border[6],
          border[6],
          '',
        },
      }
    end
  end
  if layout == 'column' then
    if type(border) == 'string' then
      return column_map[border]
    end
    if vim.tbl_islist(border) then
      return {
        {
          border[1],
          border[2],
          border[3],
          border[4],
          '',
          '',
          '',
          border[8],
        },
        {
          '',
          '',
          '',
          border[4],
          border[5],
          border[6],
          border[7],
          border[8],
        },
      }
    end
  end
end

local M = { create_border = create_border }
return M
