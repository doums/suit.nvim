## suit.nvim

A [neovim](https://neovim.io/) plugin that replaces the default
`vim.ui.input` and `vim.ui.select` implementations with floating
windows.

### Install

Use your plugin manager, eg. with `lazy.nvim`

```lua
{
  'doums/suit.nvim',
  event = 'VeryLazy',
  opts = {
    -- your optional config
  }
}
```

### Configuration

Configuration is optional.\
This is the default config:

```lua
{
  input = {
    -- default prompt value
    default_prompt = 'Input',
    -- border of the window, defaults to `vim.o.winborder` (:h winborder)
    -- border = 'single',
    -- highlight group for the input UI window
    -- links to NormalFloat
    hl_win = 'suitWin',
    -- highlight group for the prompt text
    -- links to FloatTitle
    hl_prompt = 'suitPrompt',
    -- prompt position, left | center | right
    prompt_pos = 'left',
    -- highlight group for the window border
    -- links to FloatBorder
    hl_border = 'suitBorder',
    -- input width (in addition to the default value)
    width = 20,
  },
  select = {
    -- default prompt value
    default_prompt = 'Select',
    -- border of the window, defaults to `vim.o.winborder` (:h winborder)
    -- border = 'single',
    -- highlight group for the select UI window
    -- links to NormalFloat
    hl_win = 'suitWin',
    -- highlight group for the prompt text
    -- links to FloatTitle
    hl_prompt = 'suitPrompt',
    -- prompt position, left | center | right
    prompt_pos = 'left',
    -- highlight group for the selected item
    -- links to PmenuSel
    hl_sel = 'suitSel',
    -- highlight group for the window border
    -- links to FloatBorder
    hl_border = 'suitBorder',
  },
}
```

[ref](https://github.com/doums/suit.nvim/blob/main/lua/suit/config.lua).

### Usage

Keymaps should be intuitive.

For input:

`<cr>` to confirm\
`<esc>` to cancel

For select:

`<cr>` and left mouse double click to confirm the selected item\
`<esc>`, `q` to cancel\
`j`, `k`, `<up>`, `<down>` to navigate

### License

Mozilla Public License 2.0
