# contrast.nvim

Minimalist OLED-optimized Neovim colorscheme with Tree-sitter support.

## Design Philosophy

- **Mono-scale color system**: Uses variations of a single hue family instead of multiple vibrant colors. Reduces cognitive load and eye fatigue.
- **OLED optimized**: Pure black background (`#000000`) for maximum power savings on OLED displays.
- **Importance-driven**: Brightness and saturation indicate importance. Keywords and declarations are brightest, comments are muted but visible.
- **Low saturation**: All colors stay below 30% saturation to avoid eye strain during long coding sessions.

## Color Hierarchy

```
Keywords/Declarations  ████████  Brightest (most important to notice)
Functions/Calls        ██████    Medium brightness
Types/Constructors     ████      Dimmer accent
Strings/Constants      ████      Warm gray (subtle distinction)
Comments               ██        Muted but visible
Background elements    █         Very subtle
```

## Supported Languages

Optimized Tree-sitter highlights for:

- **Config**: YAML, JSON, TOML
- **Systems**: Rust, C, C++, Zig
- **Enterprise**: Java, Scala, TypeScript, JavaScript
- **Functional**: Go
- **Scripting**: Lua, Vimscript, Bash

## Installation

### lazy.nvim (Recommended)

```lua
{
  "zerosign/contrast.nvim",
  priority = 1000,
  opts = {
    accent = 160,  -- teal (0-360 hue in degrees)
  },
  config = function(_, opts)
    require("contrast").setup(opts)
    vim.cmd("colorscheme contrast")
  end,
}
```

### Local (from filesystem)

```lua
{
  dir = "~/path/to/contrast.nvim",
  name = "contrast",
  priority = 1000,
  opts = {},
  config = function(_, opts)
    require("contrast").setup(opts)
    vim.cmd("colorscheme contrast")
  end,
}
```

## Configuration

```lua
require("contrast").setup({
  -- Accent hue in degrees (0-360)
  -- Determines the accent color for keywords, types, and highlights
  -- Examples: 0=red, 30=orange, 120=green, 160=teal, 220=blue-gray (default), 280=purple
  accent = 220,

  -- Remove background for terminal transparency
  transparent = false,

  -- Highlight current line
  cursorline = true,

  -- Plugin integrations
  integrations = {
    treesitter = true,
    telescope = true,
    neotree = true,
    gitsigns = true,
    lazy = true,
    mason = true,
    which_key = true,
    fidget = true,
    mini = true,
    indent_blankline = true,
    diffview = true,
  },
})
```

## Commands

### Runtime accent color

Change the accent color at runtime (palette is cached, no performance impact):

```vim
" Cycle through preset hues (bind these in your config)
:lua require("contrast").set_accent(160)   " teal
:lua require("contrast").set_accent(220)   " blue-gray (default)
:lua require("contrast").set_accent(0)     " red
:lua print(require("contrast").get_hue())  " show current accent
```

### Background mode

Switch via standard vim option:

```vim
:set background=dark
:set background=light
```

The theme responds to `OptionSet` automatically.

## Recommended Settings

```vim
set termguicolors
set nocursorcolumn
set noshowmode  " Statusline shows mode

" Recommended fonts
" - Intel One Mono
" - UbuntuMono Nerd Font Propo
```

## How It Works

### Dark Mode

- Background: `#000000` (pure black for OLED)
- Text: `#d4d4d8` (soft gray, not pure white)
- Keywords: `#8b9cc7` (muted blue-gray, brightest accent)
- Comments: `#71717a` (visible but not distracting)

### Light Mode

- Background: `#fafafa` (off-white, reduced glare)
- Text: `#27272a` (dark gray, not pure black)
- Keywords: `#4a5a8a` (deeper blue-gray)
- Comments: `#71717a` (same muted tone)

## Plugin Support

Built-in highlights for:

- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [which-key.nvim](https://github.com/folke/which-key.nvim)
- [fidget.nvim](https://github.com/j-hui/fidget.nvim)
- [mini.nvim](https://github.com/echasnovski/mini.nvim)
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
- [diffview.nvim](https://github.com/sindrets/diffview.nvim)

## License

MIT
