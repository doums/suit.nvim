## suit.nvim

A [neovim](https://neovim.io/) plugin that replaces the default
`vim.ui.input` with floating window.

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
  hl_prompt_win = 'suitPrompt',
  hl_prompt_border = 'suitPrompt',
  hl_input_win = 'suitInput',
  hl_input_border = 'suitInput',
})
```

All default values are listed
[here](https://github.com/doums/suit.nvim/blob/main/lua/suit/config.lua).

```lua
local _config = {
  default_prompt = '→ ',
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
}
```

### License

Mozilla Public License 2.0
