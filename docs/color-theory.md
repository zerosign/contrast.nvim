# Color Theory & Ergonomics in contrast.nvim

This document details the color science, optical ergonomics, and architectural decisions behind **contrast.nvim**, specifically addressing common pitfalls in monochrome + accent colorschemes on modern displays (OLED, Retina, high-DPI).

---

## 1. The Monochrome + Accent Philosophy

In traditional syntax themes (e.g., standard Dracula, Monokai, Solarized), 10 to 15 competing hues are scattered across every line of code. Research into cognitive load and developer tooling (notably Nikita Prokopov’s *Alabaster*) highlights that when *everything* is colored, color ceases to carry semantic value and instead acts as visual noise.

A true **mono-scale + accent** system operates on strict visual hierarchy:
1. **Structural syntax glue** (brackets, operators, punctuation) sits at low visual salience so it does not visually crowd code tokens.
2. **Body text** (identifiers, variables, fields) is clear, soft monochrome with comfortable contrast.
3. **Headings & definitions** (functions, methods) occupy peak luminance to serve as scanning anchors.
4. **Semantic control & types** (keywords, storage modifiers, types) receive the intentional accent hue with calibrated luminance.
5. **Literal data** (constants, numbers, strings) receives a harmonious warm tone to distinguish logic from data.

---

## 2. The 4-Layer Semantic Model (Why 1 Accent is Enough)

In typed languages (such as Rust, TypeScript, Go, Java), attempting to use multiple accent tiers (e.g., `primary` for keywords, `secondary` for attributes, `tertiary` for types) creates a **"Blue Soup"**:
- Keywords are blue
- Attributes (`#[derive]`, `#[from]`) are blue
- Types (`Result`, `Vec`, `String`, `StorageError`) are blue
- Modules (`thiserror`, `redb`, `std::io`) are blue
- Enum variants (`Database`, `Transaction`) are blue

When 70%–80% of the buffer is tinted with the same hue, it ceases to be an accent. The eye cannot distinguish between a keyword, a type, and an attribute.

### The Correct Model:
```
┌─────────────────────────────────────────────────────────────┐
│ 1. Structural Anchors (10-15%)  → THE SINGLE ACCENT HUE     │
│    Keywords (fn, pub, enum, let, if, return, use)           │
├─────────────────────────────────────────────────────────────┤
│ 2. Core Substance (50-60%)      → CRISP MONOCHROME          │
│    Types & Structs (StorageError, Result, Vec)   [Peak White]│
│    Functions & Calls (list_names, split_once)    [Peak White]│
│    Variables & Fields (rtx, names, tmpls)        [Soft Gray] │
├─────────────────────────────────────────────────────────────┤
│ 3. Data Literals (15-20%)       → WARM TONES                │
│    Numbers, Booleans (0, 42, true)               [Sand]      │
│    Strings ("Database error", '/')               [Parchment] │
├─────────────────────────────────────────────────────────────┤
│ 4. Supporting Glue (15-20%)     → SUBDUED MONOCHROME        │
│    Operators & Delimiters (::, ->, ?, =, +)      [Mid Gray]  │
│    Attributes & Modules (#[derive], redb::)      [Muted Italic│
│    Comments & Inlay Hints (: ReadTransaction)    [Ghost Gray]│
└─────────────────────────────────────────────────────────────┘
```

Now, every visual channel carries unambiguous meaning:
- **Accent (Blue/Teal):** Tells you *how the program flows* (control syntax).
- **Crisp White (Peak):** Identifies *what data structures and functions exist*.
- **Warm Sand:** Distinguishes *runtime data literals*.
- **Muted Gray:** Keeps compiler metadata (`#[derive]`) and path prefixes (`std::io::`) from competing with the actual types.

---

## 3. Pitfalls We Fixed: Why Themes Cause Squinting

### A. The Inverted Luminance Hierarchy
Human eye ergonomics prioritize luminance over hue: the eye focuses first on whatever has the highest luminance contrast against the background.

In the initial implementation:
- Functions (`#e4e4e7`) and plain variables (`#d4d4d8`) had peak luminance (`CR 14:1 – 16:1`).
- Keywords (`#7a8fb8`, lightness 60%) had luminance `0.27` (`CR 6.4:1`) — **half the brightness of plain variables**.
- Types (`#556991`, lightness 45%) had luminance `0.14` (`CR 3.8:1`) — **darker than comments and failing basic WCAG AA**.

Because the structural anchors (keywords and types) were substantially darker than variables, reading dense code caused eye fatigue: the eye had to constantly strain and squint to resolve dimmer keywords and types amidst glowing variables.

**The Fix:** 
- Types and constructors are mapped to peak crisp monochrome (`#ededf0`), making them immediately sharp and legible.
- Keywords are calibrated to high-clarity lightness (`76%` in dark mode, `28%` in light mode), guaranteeing clean readability and proper visual hierarchy.

---

### B. OLED Halation & The Helmholtz-Kohlrausch Effect
On OLED displays, individual pixels turn completely off for pitch black (`#000000`).
- **Halation / Glare:** High-contrast pure white text (`#ffffff` or `#e4e4e7`) against `#000000` causes light scattering inside the eye (especially for anyone with mild astigmatism), constricting the iris.
- **The Blind Spot:** When the iris constricts for bright variables, dimmer colors (like dark slate types or muted strings) sink into the black background, requiring squinting.
- **Helmholtz-Kohlrausch Effect:** The human eye's spectral sensitivity peaks at ~555 nm (green-yellow) and drops drastically at ~450 nm (blue). Saturated blue hues always appear perceptually much darker than their mathematical lightness. A 45% lightness blue against pure black looks like dark ink on black paper.

**The Fix:**
1. Base text (`fg`) is softened to `#c8c8cf` (luminance `0.58`) to eliminate halation glare while preserving a crisp `12.6:1` contrast ratio.
2. Accent lightness and saturation curves are lifted to ensure adequate perceived luminance regardless of the selected hue.

---

### C. The "Muddy Warm" Uncanny Valley
In the original theme, constants and numbers used `hsl(35, 12, 62)` and strings used `hsl(35, 10, 50)`. 

At only 10%–12% saturation, warm hues (orange/yellow/brown) fall into an optical "uncanny valley":
- The brain attempts to parse the token as neutral gray, but a subtle brownish-yellow cast makes it appear discolored or dirty.
- Against cool slate-blue accents and clean zinc monochrome, this muddy brown appeared unnatural and jarring.

**The Fix:**
- **Dark mode:** Constants use clean golden sand (`hsl(38, 38, 74)` / `#d6c3a4`), and strings use warm parchment (`hsl(38, 30, 65)` / `#c1ad8b`).
- **Light mode:** Constants use deep warm bronze (`hsl(35, 55, 30)` / `#775422`), and strings use rich sepia (`hsl(35, 45, 36)` / `#856332`).

---

### D. Inlay Hints & Floating Window Opacity
- **Ghost Inlay Hints:** Background boxes on `LspInlayHint` (`bg = p.bg_subtle`) create dark rectangular smudges in typed code. Inlay hints now render with no background box (`{ fg = p.fg_faint, italic = true }`), acting as gentle ghost text.
- **Floating Window Solid Opacity:** In floating views (such as Neogit status/diffs), `NeogitNormal` and `NeogitNormalFloat` enforce solid background colors (`#000000` / `#fafafa`) so underlying buffer text never leaks through.

---

## 4. Git & Diff Ergonomics (Neogit / Diffview)

By default, git tools often fall back to aggressive primary colors:
- Obnoxious gray hunk headers (`@@ -765,7 +765,7 @@`) that cut across the screen like slabs.
- Blinding fluorescent green and red lines that fatigue the eyes during long code reviews.

`contrast.nvim` treats diffs with the same restraint:
1. **Calm Hunk Headers:** `NeogitHunkHeader` uses subdued background dividers (`bg = p.bg_subtle`) that demarcate changes without dominating the screen.
2. **Restrained Additions (`+`):** Subtle dark forest tint background (`#14241c`) with soft mint green text (`#a3dcbf`). Word-level changes highlight cleanly with `#1f4733`.
3. **Restrained Deletions (`-`):** Subtle dark wine tint background (`#241414`) with soft coral red text (`#dca3a3`). Word-level changes highlight cleanly with `#471f1f`.
4. **Light Mode Symmetry:** Additions use soft mint parchment (`#e2f3eb`) with forest green text (`#196640`); deletions use soft rose (`#f4e6e6`) with deep crimson text (`#832121`).

---

## 5. Contrast Ratios & Luminance Tables

Both variants are calibrated for WCAG AAA compliance and APCA perceptual comfort.

### Dark Variant (OLED `#000000`, Default Accent Hue 220)

| Token | Group / Role | Hex | Luminance | Contrast vs `#000000` |
| :--- | :--- | :--- | :--- | :--- |
| **Peak Elements** | `@function`, `@type`, Constructors | `#ededf0` | `0.85` | **18.0 : 1** (WCAG AAA) |
| **Variables / Identifiers** | `@variable`, `@property` | `#c8c8cf` | `0.58` | **12.6 : 1** (WCAG AAA, anti-glare) |
| **Keywords** | `@keyword`, Control flow | `#a2b7e2` | `0.47` | **10.4 : 1** (WCAG AAA) |
| **Constants / Numbers** | `@constant`, `@number` | `#d6c3a4` | `0.56` | **12.2 : 1** (WCAG AAA) |
| **Strings** | `@string`, `@character` | `#c1ad8b` | `0.43` | **9.6 : 1** (WCAG AAA) |
| **Diff Additions** | `DiffAdd`, `NeogitDiffAdd` | `#a3dcbf` on `#14241c` | `0.65` | **10.2 : 1** (Gentle mint) |
| **Diff Deletions** | `DiffDelete`, `NeogitDiffDelete` | `#dca3a3` on `#241414` | `0.45` | **7.8 : 1** (Gentle coral) |
| **Operators / Punctuation** | `@operator`, `@punctuation` | `#8e8e98` | `0.27` | **6.5 : 1** (Secondary structure) |
| **Attributes / Modules** | `@attribute`, `@module` | `#8e8e98` | `0.27` | **6.5 : 1** (Subdued italic) |
| **Comments** | `@comment` | `#63636e` | `0.13` | **3.5 : 1** (Legible, non-distracting) |
| **Inlay Hints / Gutter** | `LspInlayHint`, `LineNr` | `#3f3f48` | `0.05` | **2.0 : 1** (Quiet ghost text) |

---

### Light Variant (Paper `#fafafa`, Default Accent Hue 220)

| Token | Group / Role | Hex | Luminance | Contrast vs `#fafafa` |
| :--- | :--- | :--- | :--- | :--- |
| **Peak Elements** | `@function`, `@type`, Constructors | `#121214` | `0.01` | **17.9 : 1** (WCAG AAA) |
| **Variables / Identifiers** | `@variable`, `@property` | `#27272a` | `0.02` | **14.3 : 1** (WCAG AAA) |
| **Keywords** | `@keyword`, Control flow | `#203a6f` | `0.04` | **10.6 : 1** (WCAG AAA) |
| **Constants / Numbers** | `@constant`, `@number` | `#775422` | `0.10` | **6.5 : 1** (WCAG AA+) |
| **Strings** | `@string`, `@character` | `#856332` | `0.14` | **5.3 : 1** (WCAG AA) |
| **Diff Additions** | `DiffAdd`, `NeogitDiffAdd` | `#196640` on `#e2f3eb` | `0.11` | **7.5 : 1** (Rich forest green) |
| **Diff Deletions** | `DiffDelete`, `NeogitDiffDelete` | `#832121` on `#f4e6e6` | `0.09` | **8.2 : 1** (Rich crimson) |
| **Operators / Punctuation** | `@operator`, `@punctuation` | `#5c5c66` | `0.11` | **6.3 : 1** (Secondary structure) |
| **Attributes / Modules** | `@attribute`, `@module` | `#5c5c66` | `0.11` | **6.3 : 1** (Subdued italic) |
| **Comments** | `@comment` | `#797985` | `0.19` | **4.1 : 1** (Legible, non-distracting) |
| **Inlay Hints / Gutter** | `LspInlayHint`, `LineNr` | `#a6a6b2` | `0.39` | **2.3 : 1** (Quiet ghost text) |

---

## 6. Architecture & Cache Strategy

`contrast.nvim` generates palette shades dynamically from an accent hue degree `[0, 360]`:

1. **On startup or `set_accent(hue)`:**
   - Both `dark` and `light` palette caches are invalidated.
   - HSL-to-RGB conversion executes **only once** for the requested hue.
   - Resulting hex colors are stored in `cached.dark` and `cached.light`.
2. **Subsequent calls (`palette.get(mode)`):**
   - Pure table lookup with $O(1)$ zero-computation cost.
3. **Switching variants:**
   - `colors/contrast.lua`: Sets `vim.o.background = "dark"` and calls `require("contrast").load()`.
   - `colors/contrast-light.lua`: Sets `vim.o.background = "light"` and calls `require("contrast").load()`.
   - Native `:set background=light` / `:set background=dark`: Triggers the `OptionSet background` autocmd which instantly retrieves the cached opposite palette.
