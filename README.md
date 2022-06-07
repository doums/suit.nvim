## suit.nvim

A [neovim](https://neovim.io/) plugin that replaces the default
`vim.ui.input` and `vim.ui.select` with floating window.

### Install

Use your plugin manager

```lua
require('paq')({
  -- ...
  'doums/suit.nvim',
})
```

### Configuration

```lua
require('suit').setup({
  input = {
    hl_prompt_win = 'suitPrompt',
    hl_prompt_border = 'suitPrompt',
    hl_input_win = 'suitInput',
    hl_input_border = 'suitInput',
  },
  select = {
    hl_prompt_win = 'suitPrompt',
    hl_prompt_border = 'suitPrompt',
    hl_select_win = 'suitInput',
    hl_select_border = 'suitInput',
    hl_selected_item = 'suitSelectedItem',
  },
})
```

All default values are listed
[here](https://github.com/doums/suit.nvim/blob/main/lua/suit/config.lua).

```lua
local _config = {
  input = {
    -- default prompt value
    default_prompt = 'Input: ',
    -- highlight group to use for input window
    hl_input_win = 'NormalFloat',
    -- highlight group to use for input border
    hl_input_border = 'FloatBorder',
    -- highlight group to use for prompt window
    hl_prompt_win = 'NormalFloat',
    -- highlight group to use for prompt border
    hl_prompt_border = 'FloatBorder',
    -- Options passed to nvim_open_win (:h nvim_open_win())
    -- You can use it to customize various things like border etc.
    input_win = {
      style = 'minimal',
      relative = 'cursor',
      width = 20,
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
  },
  select = {
    -- default prompt value
    default_prompt = 'Select one of: ',
    -- highlight group to use for select window
    hl_select_win = 'NormalFloat',
    -- highlight group to use for select border
    hl_select_border = 'FloatBorder',
    -- highlight group to use for prompt window
    hl_prompt_win = 'NormalFloat',
    -- highlight group to use for prompt border
    hl_prompt_border = 'FloatBorder',
    -- highlight group to use for current selected item
    hl_selected_item = 'PmenuSel',
    -- Options passed to nvim_open_win (:h nvim_open_win())
    -- You can use it to customize various things like border etc.
    select_win = {
      style = 'minimal',
      relative = 'cursor',
      width = 25,
      height = 1,
      zindex = 200,
      row = 2,
      col = 0,
      border = { '', '', '', ' ', '', '', '', ' ' },
    },
    prompt_win = {
      style = 'minimal',
      relative = 'cursor',
      width = 25,
      height = 1,
      zindex = 200,
      row = 1,
      col = 0,
      border = { '', '', '', ' ', '', '', '', ' ' },
      focusable = false,
    },
  },
}
```

### License

Mozilla Public License 2.0
