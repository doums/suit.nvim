## suit.nvim

A [neovim](https://neovim.io/) plugin that replaces the default
`vim.ui.input` and `vim.ui.select` implementations with floating
windows.

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
    -- default prompt value
    default_prompt = 'Input: ',
    -- border of the window (see `:h nvim_open_win`)
    border = 'single',
    -- highlight group for input
    hl_input = 'NormalFloat',
    -- highlight group for prompt
    hl_prompt = 'NormalFloat',
    -- highlight group for window border
    hl_border = 'FloatBorder',
    -- input width (in addition to the default value)
    width = 20,
  },
  select = {
    -- default prompt value
    default_prompt = 'Select one of: ',
    -- border of the window (see `:h nvim_open_win`)
    border = 'single',
    -- highlight group for select list
    hl_select = 'NormalFloat',
    -- highlight group for prompt
    hl_prompt = 'NormalFloat',
    -- highlight group for current selected item
    hl_selected_item = 'PmenuSel',
    -- highlight group for window border
    hl_border = 'FloatBorder',
  },
})
```

All default configuration values are listed
[here](https://github.com/doums/suit.nvim/blob/main/lua/suit/config.lua).

### License

Mozilla Public License 2.0
