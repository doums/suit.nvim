## suit.nvim

A neovim plugin that provides implementation of `vim.ui.input`
and `vim.ui.select` using **floating windows**

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
    -- prompt position, left | center | right
    prompt_pos = 'left',
    -- input width (in addition to the default value)
    width = 20,
    max_width = 50,
  },
  select = {
    -- default prompt value
    default_prompt = 'Select',
    -- border of the window, defaults to `vim.o.winborder` (:h winborder)
    -- border = 'single',
    -- prompt position, left | center | right
    prompt_pos = 'left',
    max_width = 40,
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

### Highlight

- `suitWin` input/select window, default: links to `NormalFloat`
- `suitBorder` window border, default: links to `FloatBorder`
- `suitPrompt` prompt text (window title), default: links to `FloatTitle`
- `suitSel` selected item, default: links to `PmenuSel`

### License

Mozilla Public License 2.0
