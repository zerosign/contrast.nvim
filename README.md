# contrast.nvim

Minimalist OLED-optimized Neovim colorscheme with Tree-sitter support.

## Design Philosophy

- **Mono-scale color system**: Uses variations of a single hue family instead of multiple vibrant colors. Reduces cognitive load and eye fatigue.
- **OLED optimized**: Pure black background (`#000000`) for maximum power savings and infinite contrast on OLED displays.
- **Importance-driven luminance hierarchy**: Contrast and perceived luminance indicate importance. Functions and declarations serve as scanning anchors, keywords provide clear structural control flow, and operators/comments stay secondary.
- **Perceptual contrast (WCAG AAA & APCA)**: Calibrated against halation/glare on dark backgrounds and washing out on paper backgrounds. See [docs/color-theory.md](docs/color-theory.md) for full color science notes.

## Color Hierarchy

```
Functions / Declarations  ██████████  Peak luminance (visual scanning anchors)
Variables / Identifiers   ████████    Softened body text (anti-glare, 12:1 - 14:1)
Keywords / Control flow   ████████    Primary accent (bold, high-clarity structural signposts)
Constants / Numbers       ████████    Warm sand / bronze (clean data distinction)
Strings                   ██████      Warm parchment / sepia
Storage / Modifiers       ██████      Secondary accent
Types / Constructors      ██████      Tertiary accent (calibrated for 7:1+ contrast)
Operators / Punctuation   ████        Syntax glue (subdued to prevent visual crowding)
Comments                  ██          Muted, legible, non-distracting
Gutter / Guides           █           Subtle background structure
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

  -- Granular font weight & style customization
  styles = {
    keywords   = { bold = true },    -- keywords & control flow
    functions  = { bold = false },   -- function declarations & calls
    types      = { bold = false },   -- types, structs, interfaces
    attributes = { italic = true },  -- attributes, decorators (#[derive], #[from])
    comments   = { italic = true },  -- comments
  },

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

Switch via standard Vim background options or colorscheme commands:

```vim
" Switch via standard option
:set background=dark
:set background=light

" Or switch via colorscheme picker / command
:colorscheme contrast        " OLED dark mode
:colorscheme contrast-light  " Off-white paper light mode
```

The theme responds to `OptionSet background` automatically and retrieves cached palettes with zero overhead.

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

Palettes are calculated once per accent hue and cached for instant switching with calibrated contrast ratios and optical ergonomics. For full contrast ratios, APCA scores, and optical ergonomics, see [docs/color-theory.md](docs/color-theory.md).

### Dark Mode (OLED pitch black)

- **Background**: `#000000` (pure black, maximum OLED battery savings)
- **Functions**: `#ededf0` (peak luminance scanning anchor, 18:1 contrast)
- **Text / Variables**: `#c8c8cf` (softened anti-glare light gray, 12.6:1 contrast)
- **Keywords**: `#a2b7e2` (crisp high-clarity accent, 10.4:1 contrast, bold)
- **Types**: `#7992c3` (calibrated tertiary accent, 6.7:1 contrast, never unreadable)
- **Constants & Numbers**: `#d6c3a4` (clean warm sand, 12.2:1 contrast)
- **Strings**: `#c1ad8b` (warm parchment, 9.6:1 contrast)
- **Comments**: `#63636e` (legible, non-distracting)

### Light Mode (Paper off-white)

- **Background**: `#fafafa` (off-white, reduced glare)
- **Functions**: `#121214` (peak contrast anchor, 17.9:1 contrast)
- **Text / Variables**: `#27272a` (dark charcoal body text, 14.3:1 contrast)
- **Keywords**: `#203a6f` (rich deep accent, 10.6:1 contrast, bold)
- **Types**: `#3c568b` (crisp tertiary accent, 6.9:1 contrast)
- **Constants & Numbers**: `#775422` (deep warm bronze, 6.5:1 contrast)
- **Strings**: `#856332` (rich warm sepia, 5.3:1 contrast)
- **Comments**: `#797985` (clear muted tone, 4.1:1 contrast)

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
- [Neogit](https://github.com/NeogitOrg/neogit)

## License

MIT
