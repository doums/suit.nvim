-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

local M = {}

local _hl = {
  win = { 'suitWin', 'NormalFloat' },
  border = { 'suitBorder', 'FloatBorder' },
  prompt = { 'suitPrompt', 'FloatTitle' },
  selected = { 'suitSel', 'PmenuSel' },
}
M.hl = {
  win = 'suitWin',
  border = 'suitBorder',
  prompt = 'suitPrompt',
  selected = 'suitSel',
}

local function hl_exists(ns, name)
  return not vim.tbl_isempty(vim.api.nvim_get_hl(ns, { name = name }))
end

function M.set_win_hl(win)
  local win_hl = table.concat(
    vim.iter(_hl):fold({}, function(acc, _, hl)
      table.insert(acc, string.format('%s:%s', hl[2], hl[1]))
      return acc
    end),
    ','
  )
  local opt = vim.wo[win].winhighlight
  if opt == '' then
    vim.wo[win].winhighlight = win_hl
  else
    vim.wo[win].winhighlight = string.format('%s,%s', opt, win_hl)
  end
end

function M.init()
  for _, map in pairs(_hl) do
    local hl = map[1]
    local builtin = map[2]
    if not hl_exists(0, hl) then
      vim.api.nvim_set_hl(0, hl, { link = builtin })
    end
  end
end

return M
