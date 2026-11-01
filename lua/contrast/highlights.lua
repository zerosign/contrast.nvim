-- contrast.nvim highlight groups
-- Tree-sitter native highlights with mono-scale color system

local M = {}

--- Build highlight groups for the given palette
---@param p table palette
---@param config? table plugin configuration
---@return table highlights
function M.build(p, config)
  config = config or {}
  local styles = vim.tbl_deep_extend("force", {
    keywords   = { bold = true },
    functions  = { bold = false },
    types      = { bold = false },
    attributes = { italic = true },
    comments   = { italic = true },
  }, config.styles or {})

  local h = {}

  -- Helper: create highlight spec
  local function hl(group, opts)
    h[group] = opts
  end

  -- Helper: link to another group
  local function link(group, target)
    h[group] = { link = target }
  end

  -- Helper: merge base style with configured font weight / style
  local function with_style(base, style)
    return vim.tbl_extend("force", base, style or {})
  end

  -- ==========================================================================
  -- Tree-sitter Highlights
  -- ==========================================================================
  -- Philosophy: 4-layer semantic model
  -- - Keywords: single accent hue
  -- - Functions & Types: peak crisp monochrome
  -- - Variables: softened monochrome body text
  -- - Literals: warm sand & parchment
  -- - Supporting glue: subdued gray

  -- Keywords: Structural flow & control
  hl("@keyword", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.function", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.return", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.operator", { fg = p.accent.primary })
  hl("@keyword.import", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.repeat", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.conditional", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.exception", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.coroutine", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.modifier", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.type", with_style({ fg = p.accent.primary }, styles.keywords))

  -- Control flow keywords (if/else/for/while/match)
  hl("@keyword.control", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.control.conditional", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.control.repeat", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.control.return", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.control.trycatch", with_style({ fg = p.accent.primary }, styles.keywords))

  -- Storage class / modifiers (pub, static, const, mut, etc.)
  hl("@keyword.storage", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.storage.modifier", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.storage.type", with_style({ fg = p.accent.primary }, styles.keywords))

  -- Definitions: where names are being declared
  hl("@keyword.definition", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.definition.function", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.definition.method", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.definition.operator", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.definition.type", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.definition.enum", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.definition.enum.variant", { fg = p.fg_bright })
  hl("@keyword.definition.struct", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.definition.interface", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.definition.namespace", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.definition.module", with_style({ fg = p.accent.primary }, styles.keywords))

  -- Functions: Peak crisp monochrome
  hl("@function", with_style({ fg = p.fg_bright }, styles.functions))
  hl("@function.builtin", with_style({ fg = p.fg_bright }, styles.functions))
  hl("@function.call", with_style({ fg = p.fg_bright }, styles.functions))
  hl("@function.declaration", with_style({ fg = p.fg_bright, bold = true }, styles.functions))
  hl("@function.method", with_style({ fg = p.fg_bright }, styles.functions))
  hl("@function.method.call", with_style({ fg = p.fg_bright }, styles.functions))

  -- Macros
  hl("@function.macro", with_style({ fg = p.accent.primary, italic = true }, styles.keywords))

  -- Methods
  hl("@method", with_style({ fg = p.fg_bright }, styles.functions))
  hl("@method.call", with_style({ fg = p.fg_bright }, styles.functions))

  -- Constructors
  hl("@constructor", with_style({ fg = p.fg_bright }, styles.types))
  hl("@constructor.lua", { fg = p.fg })

  -- Types: Peak crisp monochrome for instant legibility
  hl("@type", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.definition", with_style({ fg = p.fg_bright, bold = true }, styles.types))
  hl("@type.qualifier", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@type.builtin.vim", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtinvim", with_style({ fg = p.fg_bright }, styles.types))

  -- Namespaces and modules: Subdued gray so path prefixes don't drown type names
  hl("@namespace", { fg = p.fg_dim })
  hl("@module", { fg = p.fg_dim })
  hl("@module.builtin", { fg = p.fg_dim })

  -- Parameters and variables
  hl("@variable", { fg = p.fg })
  hl("@variable.builtin", { fg = p.fg_dim })
  hl("@variable.parameter", { fg = p.fg_dim })
  hl("@variable.member", { fg = p.fg })

  -- Properties and fields
  hl("@property", { fg = p.fg })
  hl("@field", { fg = p.fg })

  -- Constants: Use warm tone for subtle distinction
  hl("@constant", { fg = p.accent.warm })
  hl("@constant.builtin", { fg = p.accent.warm })
  hl("@constant.macro", { fg = p.accent.warm })

  -- Literals
  hl("@boolean", { fg = p.accent.warm })
  hl("@number", { fg = p.accent.warm })
  hl("@number.float", { fg = p.accent.warm })
  hl("@string", { fg = p.accent.warm_dim })
  hl("@string.regexp", { fg = p.accent.warm_dim })
  hl("@string.escape", { fg = p.accent.warm })
  hl("@string.special", { fg = p.accent.warm })
  hl("@string.special.symbol", { fg = p.accent.warm })
  hl("@string.regexp.vim", { fg = p.accent.warm_dim })
  hl("@character", { fg = p.accent.warm_dim })
  hl("@character.special", { fg = p.accent.warm })

  -- Comments: Visible but muted - important for code comprehension
  hl("@comment", with_style({ fg = p.fg_muted }, styles.comments))
  hl("@comment.documentation", with_style({ fg = p.fg_dim }, styles.comments))
  hl("@comment.error", with_style({ fg = p.diagnostic.error }, styles.comments))
  hl("@comment.warning", with_style({ fg = p.diagnostic.warn }, styles.comments))
  hl("@comment.todo", { fg = p.diagnostic.info, italic = true, bold = true })
  hl("@comment.note", { fg = p.diagnostic.hint, italic = true })
  hl("@comment.fix", { fg = p.diagnostic.info, italic = true, bold = true })

  -- Punctuation: Very subtle
  hl("@punctuation", { fg = p.fg_dim })
  hl("@punctuation.delimiter", { fg = p.fg_dim })
  hl("@punctuation.bracket", { fg = p.fg_dim })
  hl("@punctuation.special", { fg = p.fg_dim })

  -- Operators
  hl("@operator", { fg = p.fg_dim })

  -- Tags (HTML/XML)
  hl("@tag", { fg = p.fg_bright })
  hl("@tag.attribute", { fg = p.fg })
  hl("@tag.delimiter", { fg = p.fg_dim })

  -- Attributes and decorators: Subdued metadata
  hl("@attribute", with_style({ fg = p.fg_dim }, styles.attributes))
  hl("@decorator", with_style({ fg = p.fg_dim }, styles.attributes))

  -- Labels
  hl("@label", { fg = p.fg_dim })

  -- Diff
  hl("@diff.plus", { fg = p.diagnostic.hint })
  hl("@diff.minus", { fg = p.diagnostic.error })
  hl("@diff.delta", { fg = p.diagnostic.warn })

  -- Error handling
  hl("@error", { fg = p.diagnostic.error })

  -- ==========================================================================
  -- LSP Semantic Tokens (Neovim 0.9+)
  -- ==========================================================================
  hl("@lsp.type.class", { fg = p.fg_bright })
  hl("@lsp.type.enum", { fg = p.fg_bright })
  hl("@lsp.type.enumMember", { fg = p.fg_bright })
  hl("@lsp.type.interface", { fg = p.fg_bright })
  hl("@lsp.type.struct", { fg = p.fg_bright })
  hl("@lsp.type.type", { fg = p.fg_bright })
  hl("@lsp.type.typeParameter", { fg = p.fg_bright })
  hl("@lsp.type.namespace", { fg = p.fg_dim })
  hl("@lsp.type.parameter", { fg = p.fg_dim })
  hl("@lsp.type.property", { fg = p.fg })
  hl("@lsp.type.variable", { fg = p.fg })
  hl("@lsp.type.function", { fg = p.fg_bright })
  hl("@lsp.type.method", { fg = p.fg_bright })
  hl("@lsp.type.macro", with_style({ fg = p.accent.primary, italic = true }, styles.keywords))
  hl("@lsp.type.keyword", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@lsp.type.comment", with_style({ fg = p.fg_muted }, styles.comments))
  hl("@lsp.type.string", { fg = p.accent.warm_dim })
  hl("@lsp.type.number", { fg = p.accent.warm })
  hl("@lsp.type.boolean", { fg = p.accent.warm })
  hl("@lsp.type.operator", { fg = p.fg_dim })
  hl("@lsp.type.decorator", with_style({ fg = p.fg_dim }, styles.attributes))

  -- ==========================================================================
  -- Language-Specific Tree-sitter & Semantic Groups
  -- ==========================================================================

  -- Rust
  hl("@type.rust", with_style({ fg = p.fg_bright }, styles.types))
  hl("@lsp.type.class.rust", with_style({ fg = p.fg_bright }, styles.types))
  hl("@lsp.type.enum.rust", with_style({ fg = p.fg_bright }, styles.types))
  hl("@lsp.type.enumMember.rust", with_style({ fg = p.fg_bright }, styles.types))
  hl("@lsp.type.struct.rust", with_style({ fg = p.fg_bright }, styles.types))
  hl("@lsp.type.type.rust", with_style({ fg = p.fg_bright }, styles.types))
  hl("@attribute.rust", with_style({ fg = p.fg_dim }, styles.attributes))
  hl("@lifetime.rust", { fg = p.accent.primary })
  hl("@attribute.lifetime.rust", { fg = p.accent.primary })
  hl("@function.macro.rust", with_style({ fg = p.accent.primary, italic = true }, styles.keywords))

  -- Go
  hl("@type.go", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.go", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.definition.go", with_style({ fg = p.fg_bright, bold = true }, styles.types))
  hl("@module.go", { fg = p.fg_dim })
  hl("@package.go", { fg = p.fg_dim })
  hl("@string.special.go", { fg = p.accent.warm_dim })

  -- TypeScript / JavaScript / JSX / TSX
  hl("@type.typescript", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.javascript", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.typescript", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.javascript", with_style({ fg = p.fg_bright }, styles.types))
  hl("@lsp.type.interface.typescript", with_style({ fg = p.fg_bright }, styles.types))
  hl("@lsp.type.type.typescript", with_style({ fg = p.fg_bright }, styles.types))
  hl("@lsp.type.class.typescript", with_style({ fg = p.fg_bright }, styles.types))
  hl("@tag.tsx", { fg = p.fg_bright })
  hl("@tag.jsx", { fg = p.fg_bright })
  hl("@tag.builtin.tsx", { fg = p.fg_bright })
  hl("@tag.builtin.jsx", { fg = p.fg_bright })
  hl("@tag.attribute.tsx", { fg = p.fg })
  hl("@tag.attribute.jsx", { fg = p.fg })
  hl("@tag.delimiter.tsx", { fg = p.fg_dim })
  hl("@tag.delimiter.jsx", { fg = p.fg_dim })

  -- HTML
  hl("@tag.html", { fg = p.fg_bright })
  hl("@tag.builtin.html", { fg = p.fg_bright })
  hl("@tag.attribute.html", { fg = p.fg })
  hl("@tag.delimiter.html", { fg = p.fg_dim })
  hl("@string.html", { fg = p.accent.warm_dim })
  hl("htmlTagName", { fg = p.fg_bright })
  hl("htmlArg", { fg = p.fg })
  hl("htmlTag", { fg = p.fg_dim })
  hl("htmlEndTag", { fg = p.fg_dim })

  -- Java
  hl("@type.java", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.java", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.annotation.java", with_style({ fg = p.fg_dim }, styles.attributes))
  hl("@module.java", { fg = p.fg_dim })

  -- Scala
  hl("@type.scala", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.scala", with_style({ fg = p.fg_bright }, styles.types))
  hl("@module.scala", { fg = p.fg_dim })
  hl("@interpolation.scala", { fg = p.accent.primary })

  -- Kotlin
  hl("@type.kotlin", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.kotlin", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.annotation.kotlin", with_style({ fg = p.fg_dim }, styles.attributes))
  hl("@attribute.kotlin", with_style({ fg = p.fg_dim }, styles.attributes))
  hl("@annotation.kotlin", with_style({ fg = p.fg_dim }, styles.attributes))
  hl("@module.kotlin", { fg = p.fg_dim })
  hl("@punctuation.special.kotlin", { fg = p.accent.primary })
  hl("@string.special.symbol.kotlin", { fg = p.accent.primary })

  -- OCaml
  hl("@type.ocaml", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.ocaml", with_style({ fg = p.fg_bright }, styles.types))
  hl("@module.ocaml", { fg = p.fg_dim })
  hl("@constructor.ocaml", with_style({ fg = p.fg_bright }, styles.types))
  hl("@operator.ocaml", { fg = p.fg_dim })

  -- Julia
  hl("@type.julia", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.julia", with_style({ fg = p.fg_bright }, styles.types))
  hl("@module.julia", { fg = p.fg_dim })
  hl("@function.macro.julia", with_style({ fg = p.accent.primary, italic = true }, styles.keywords))
  hl("@macro.julia", with_style({ fg = p.accent.primary, italic = true }, styles.keywords))
  hl("@string.special.symbol.julia", { fg = p.accent.warm })

  -- Python
  hl("@type.python", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.python", with_style({ fg = p.fg_bright }, styles.types))
  hl("@decorator.python", with_style({ fg = p.fg_dim }, styles.attributes))
  hl("@attribute.python", with_style({ fg = p.fg_dim }, styles.attributes))
  hl("@variable.builtin.python", { fg = p.fg_dim })
  hl("@function.builtin.python", with_style({ fg = p.fg_bright }, styles.functions))
  hl("@string.special.python", { fg = p.accent.warm_dim })
  hl("@punctuation.special.python", { fg = p.accent.primary })

  -- Markdown
  hl("@markup.heading", { fg = p.fg_bright, bold = true })
  hl("@markup.heading.1", { fg = p.fg_bright, bold = true })
  hl("@markup.heading.2", { fg = p.fg_bright, bold = true })
  hl("@markup.heading.3", { fg = p.fg_bright, bold = true })
  hl("@markup.heading.4", { fg = p.fg_bright, bold = true })
  hl("@markup.heading.5", { fg = p.fg_bright, bold = true })
  hl("@markup.heading.6", { fg = p.fg_bright, bold = true })
  hl("markdownH1", { fg = p.fg_bright, bold = true })
  hl("markdownH2", { fg = p.fg_bright, bold = true })
  hl("markdownH3", { fg = p.fg_bright, bold = true })
  hl("markdownH4", { fg = p.fg_bright, bold = true })
  hl("markdownH5", { fg = p.fg_bright, bold = true })
  hl("markdownH6", { fg = p.fg_bright, bold = true })
  hl("@markup.strong", { bold = true })
  hl("@markup.italic", { italic = true })
  hl("@markup.strikethrough", { strikethrough = true })
  hl("@markup.link", { fg = p.accent.primary, underline = true })
  hl("@markup.link.url", { fg = p.fg_dim, underline = true })
  hl("@markup.link.label", { fg = p.accent.primary })
  hl("@markup.raw", { fg = p.accent.warm })
  hl("@markup.raw.block", { fg = p.fg })
  hl("@markup.list", { fg = p.fg_dim })
  hl("@markup.list.checked", { fg = p.diagnostic.hint })
  hl("@markup.list.unchecked", { fg = p.fg_dim })
  hl("@markup.quote", { fg = p.fg_muted, italic = true })

  -- AsciiDoc
  hl("@markup.heading.asciidoc", { fg = p.fg_bright, bold = true })
  hl("@markup.link.asciidoc", { fg = p.accent.primary, underline = true })
  hl("@markup.link.url.asciidoc", { fg = p.fg_dim, underline = true })
  hl("@markup.raw.asciidoc", { fg = p.accent.warm })
  hl("@attribute.asciidoc", { fg = p.fg_dim })
  hl("@markup.list.asciidoc", { fg = p.fg_dim })
  hl("@markup.strong.asciidoc", { bold = true })
  hl("@markup.italic.asciidoc", { italic = true })

  -- Fish Shell
  hl("@function.fish", with_style({ fg = p.fg_bright }, styles.functions))
  hl("@function.builtin.fish", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@keyword.fish", with_style({ fg = p.accent.primary }, styles.keywords))
  hl("@variable.fish", { fg = p.fg })
  hl("@variable.parameter.fish", { fg = p.fg_dim })
  hl("@operator.fish", { fg = p.fg_dim })

  -- C/C++
  hl("@type.c", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.cpp", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.c", with_style({ fg = p.fg_bright }, styles.types))
  hl("@type.builtin.cpp", with_style({ fg = p.fg_bright }, styles.types))

  -- Zig
  hl("@type.zig", with_style({ fg = p.fg_bright }, styles.types))

  -- Prolog
  hl("@type.prolog", with_style({ fg = p.fg_bright }, styles.types))

  -- Config files (YAML, JSON, TOML) - Peak crisp monochrome keys for immediate scannability
  hl("@property.yaml", { fg = p.fg_bright })
  hl("@field.yaml", { fg = p.fg_bright })
  hl("@property.json", { fg = p.fg_bright })
  hl("@property.toml", { fg = p.fg_bright })
  hl("@string.special.path.yaml", { fg = p.accent.warm_dim })
  hl("@string.special.path.json", { fg = p.accent.warm_dim })

  -- Lua
  hl("@variable.builtin.lua", { fg = p.fg_bright })
  hl("@constructor.lua", { fg = p.fg })
  hl("@property.lua", { fg = p.fg })

  -- Vim
  hl("@function.builtin.vim", { fg = p.fg })
  hl("@variable.builtin.vim", { fg = p.fg_bright })
  hl("@keyword.vim", { fg = p.accent.primary })

  -- ==========================================================================
  -- Editor UI Highlights
  -- ==========================================================================

  -- General UI
  hl("Normal", { fg = p.fg, bg = p.bg })
  hl("NormalFloat", { fg = p.fg, bg = p.bg_subtle })
  hl("NormalNC", { fg = p.fg_dim, bg = p.bg })

  -- Cursor
  hl("Cursor", { fg = p.bg, bg = p.fg })
  hl("lCursor", { fg = p.bg, bg = p.fg })
  hl("CursorIM", { fg = p.bg, bg = p.fg })
  hl("CursorLine", { bg = p.cursor_line })
  hl("CursorColumn", { bg = p.cursor_line })

  -- Color column (80-char ruler). Also used by render-markdown.nvim as the
  -- fenced code block background (RenderMarkdownCode -> ColorColumn), so it
  -- must be themed: the Neovim default (NvimLightGrey4) clashes badly with
  -- the light palette and tanks contrast for code block text.
  hl("ColorColumn", { bg = p.bg_subtle })

  -- Line numbers
  hl("LineNr", { fg = p.fg_faint })
  hl("CursorLineNr", { fg = p.fg_dim })

  -- Sign column
  hl("SignColumn", { fg = p.fg_faint, bg = p.bg })
  hl("FoldColumn", { fg = p.fg_faint, bg = p.bg })
  hl("Folded", { fg = p.fg_muted, bg = p.bg_dim })

  -- Status line
  hl("StatusLine", { fg = p.fg, bg = p.bg_subtle })
  hl("StatusLineNC", { fg = p.fg_muted, bg = p.bg_dim })

  -- Winbar
  hl("WinBar", { fg = p.fg_dim, bg = p.bg })
  hl("WinBarNC", { fg = p.fg_faint, bg = p.bg })

  -- Tab line
  hl("TabLine", { fg = p.fg_dim, bg = p.bg_dim })
  hl("TabLineFill", { bg = p.bg_dim })
  hl("TabLineSel", { fg = p.fg, bg = p.bg_subtle, bold = true })

  -- Popup menu
  hl("Pmenu", { fg = p.fg, bg = p.bg_subtle })
  hl("PmenuSel", { fg = p.fg_bright, bg = p.bg_highlight })
  hl("PmenuSbar", { bg = p.bg_subtle })
  hl("PmenuThumb", { bg = p.border })

  -- Search
  hl("Search", { fg = p.bg, bg = p.fg_muted })
  hl("IncSearch", { fg = p.bg, bg = p.fg })
  hl("CurSearch", { link = "IncSearch" })
  hl("Substitute", { fg = p.bg, bg = p.diagnostic.warn })

  -- Selection
  hl("Visual", { bg = p.visual })
  hl("VisualNOS", { bg = p.visual })

  -- Matching
  hl("MatchParen", { bg = p.match_paren, bold = true })

  -- Non-text
  hl("NonText", { fg = p.fg_faint })
  hl("SpecialKey", { fg = p.fg_faint })

  -- Spell checking
  hl("SpellBad", { fg = p.diagnostic.error, undercurl = true })
  hl("SpellCap", { fg = p.diagnostic.warn, undercurl = true })
  hl("SpellLocal", { fg = p.diagnostic.info, undercurl = true })
  hl("SpellRare", { fg = p.diagnostic.hint, undercurl = true })

  -- Diagnostic underlines
  hl("DiagnosticUnderlineError", { undercurl = true, sp = p.diagnostic.error })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.diagnostic.warn })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.diagnostic.info })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.diagnostic.hint })

  -- Diagnostic signs (in sign column)
  hl("DiagnosticSignError", { fg = p.diagnostic.error })
  hl("DiagnosticSignWarn", { fg = p.diagnostic.warn })
  hl("DiagnosticSignInfo", { fg = p.diagnostic.info })
  hl("DiagnosticSignHint", { fg = p.diagnostic.hint })

  -- Diagnostic virtual text
  hl("DiagnosticVirtualTextError", { fg = p.diagnostic.error, bg = p.bg_dim })
  hl("DiagnosticVirtualTextWarn", { fg = p.diagnostic.warn, bg = p.bg_dim })
  hl("DiagnosticVirtualTextInfo", { fg = p.diagnostic.info, bg = p.bg_dim })
  hl("DiagnosticVirtualTextHint", { fg = p.diagnostic.hint, bg = p.bg_dim })

  -- LSP Inlay Hints (Neovim 0.10+): subtle ghost text, no background box
  hl("LspInlayHint", { fg = p.fg_faint, italic = true })

  -- LSP Document Highlights
  hl("LspReferenceText", { bg = p.bg_highlight })
  hl("LspReferenceRead", { bg = p.bg_highlight })
  hl("LspReferenceWrite", { bg = p.bg_highlight })

  -- Floating windows
  hl("FloatBorder", { fg = p.border, bg = p.bg_subtle })
  hl("FloatTitle", { fg = p.fg_bright, bg = p.bg_subtle, bold = true })
  hl("NormalFloat", { fg = p.fg, bg = p.bg_subtle })

  -- Window separators
  hl("WinSeparator", { fg = p.border })

  -- Title
  hl("Title", { fg = p.fg_bright, bold = true })

  -- Highlight groups
  hl("HighlightedyankRegion", { bg = p.visual })

  -- Lazy.nvim
  hl("LazyButton", { fg = p.fg, bg = p.bg_subtle })
  hl("LazyButtonActive", { fg = p.fg_bright, bg = p.bg_highlight, bold = true })
  hl("LazyComment", { fg = p.fg_muted })
  hl("LazyH1", { fg = p.fg_bright, bold = true })
  hl("LazyH2", { fg = p.fg, bold = true })
  hl("LazyNormal", { fg = p.fg, bg = p.bg_subtle })
  hl("LazyReasonPlugin", { fg = p.accent.primary })

  -- Mason
  hl("MasonHeader", { fg = p.fg_bright, bold = true })
  hl("MasonNormal", { fg = p.fg, bg = p.bg_subtle })

  -- Neotree
  hl("NeoTreeNormal", { fg = p.fg, bg = p.bg })
  hl("NeoTreeNormalNC", { fg = p.fg_dim, bg = p.bg })
  hl("NeoTreeDirectoryName", { fg = p.fg_dim })
  hl("NeoTreeDirectoryIcon", { fg = p.fg_muted })
  hl("NeoTreeRootName", { fg = p.fg_bright, bold = true })
  hl("NeoTreeFileName", { fg = p.fg })
  hl("NeoTreeFileIcon", { fg = p.fg_muted })
  hl("NeoTreeFileNameOpened", { fg = p.fg_bright })
  hl("NeoTreeFloatBorder", { fg = p.border, bg = p.bg_subtle })
  hl("NeoTreeFloatTitle", { fg = p.fg_bright, bold = true })
  hl("NeoTreeIndentMarker", { fg = p.fg_faint })
  hl("NeoTreeDimText", { fg = p.fg_faint })

  -- Telescope
  hl("TelescopeNormal", { fg = p.fg, bg = p.bg_subtle })
  hl("TelescopeBorder", { fg = p.border, bg = p.bg_subtle })
  hl("TelescopeTitle", { fg = p.fg_bright, bold = true })
  hl("TelescopeSelection", { fg = p.fg_bright, bg = p.bg_highlight })
  hl("TelescopeSelectionCaret", { fg = p.accent.primary })
  hl("TelescopeMultiSelection", { fg = p.accent.secondary })
  hl("TelescopeMatching", { fg = p.accent.primary, bold = true })
  hl("TelescopePromptPrefix", { fg = p.accent.primary })
  hl("TelescopePromptNormal", { fg = p.fg, bg = p.bg_subtle })
  hl("TelescopePromptBorder", { fg = p.border, bg = p.bg_subtle })
  hl("TelescopePromptTitle", { fg = p.fg_bright, bold = true })
  hl("TelescopeResultsNormal", { fg = p.fg, bg = p.bg_subtle })
  hl("TelescopeResultsBorder", { fg = p.border, bg = p.bg_subtle })
  hl("TelescopeResultsTitle", { fg = p.fg_bright, bold = true })
  hl("TelescopePreviewNormal", { fg = p.fg, bg = p.bg })
  hl("TelescopePreviewBorder", { fg = p.border, bg = p.bg })
  hl("TelescopePreviewTitle", { fg = p.fg_bright, bold = true })

  -- Fidget (LSP progress)
  hl("FidgetTitle", { fg = p.accent.primary, bold = true })
  hl("FidgetTask", { fg = p.fg_muted })

  -- Indent blankline
  hl("IndentBlanklineChar", { fg = p.indent })
  hl("IndentBlanklineContextChar", { fg = p.fg_faint })
  hl("IblIndent", { fg = p.indent })
  hl("IblScope", { fg = p.fg_faint })

  -- Which-key
  hl("WhichKey", { fg = p.fg_bright })
  hl("WhichKeyGroup", { fg = p.accent.primary })
  hl("WhichKeyDesc", { fg = p.fg })
  hl("WhichKeySeparator", { fg = p.fg_muted })
  hl("WhichKeyFloat", { bg = p.bg_subtle })
  hl("WhichKeyBorder", { fg = p.border })

  -- Gitsigns
  hl("GitSignsAdd", { fg = p.diagnostic.hint })
  hl("GitSignsChange", { fg = p.diagnostic.warn })
  hl("GitSignsDelete", { fg = p.diagnostic.error })
  hl("GitSignsTopDelete", { fg = p.diagnostic.error })
  hl("GitSignsChangedelete", { fg = p.diagnostic.warn })

  -- Diff (Standard Vim & Diffview)
  hl("DiffAdd", { fg = p.diff.add_fg, bg = p.diff.add_bg })
  hl("DiffChange", { bg = p.diff.change_bg })
  hl("DiffDelete", { fg = p.diff.del_fg, bg = p.diff.del_bg })
  hl("DiffText", { fg = p.diff.change_fg, bg = p.diff.change_bg, bold = true })
  hl("diffAdded", { fg = p.diff.add_fg, bg = p.diff.add_bg })
  hl("diffRemoved", { fg = p.diff.del_fg, bg = p.diff.del_bg })
  hl("diffChanged", { fg = p.diff.change_fg, bg = p.diff.change_bg })
  hl("diffLine", { fg = p.fg_dim, bg = p.bg_subtle, bold = true })
  hl("diffSubname", { fg = p.fg_muted })

  -- Neogit
  hl("NeogitNormal", { fg = p.fg, bg = p.bg })
  hl("NeogitNormalFloat", { fg = p.fg, bg = p.bg })
  hl("NeogitFloat", { fg = p.fg, bg = p.bg })
  hl("NeogitFloatBorder", { fg = p.border, bg = p.bg })
  hl("NeogitFloatHeader", { fg = p.fg_bright, bg = p.bg_subtle, bold = true })
  hl("NeogitFloatHeaderHighlight", { fg = p.accent.primary, bg = p.bg_subtle, bold = true })
  hl("NeogitCursorLine", { bg = p.cursor_line })
  hl("NeogitCursorLineNr", { fg = p.fg_dim })
  hl("NeogitActiveItem", { fg = p.accent.primary, bg = p.bg_highlight, bold = true })

  -- Neogit Hunk & Diff Headers (replaces glaring gray slabs)
  hl("NeogitHunkHeader", { fg = p.fg_dim, bg = p.bg_subtle, bold = true })
  hl("NeogitHunkHeaderHighlight", { fg = p.accent.primary, bg = p.bg_highlight, bold = true })
  hl("NeogitHunkHeaderCursor", { fg = p.accent.primary, bg = p.bg_highlight, bold = true })
  hl("NeogitHunkMergeHeader", { fg = p.fg_dim, bg = p.bg_subtle, bold = true })
  hl("NeogitHunkMergeHeaderHighlight", { fg = p.accent.primary, bg = p.bg_highlight, bold = true })
  hl("NeogitHunkMergeHeaderCursor", { fg = p.accent.primary, bg = p.bg_highlight, bold = true })
  hl("NeogitDiffHeader", { fg = p.fg_bright, bg = p.bg_subtle, bold = true })
  hl("NeogitDiffHeaderHighlight", { fg = p.accent.primary, bg = p.bg_highlight, bold = true })

  -- Neogit Diff Context & Lines
  hl("NeogitDiffContext", { bg = p.bg })
  hl("NeogitDiffContextHighlight", { bg = p.bg_dim })
  hl("NeogitDiffContextCursor", { bg = p.bg_subtle })

  -- Neogit Additions & Deletions
  hl("NeogitDiffAdd", { fg = p.diff.add_fg, bg = p.diff.add_bg })
  hl("NeogitDiffAddHighlight", { fg = p.diff.add_fg, bg = p.diff.add_bg })
  hl("NeogitDiffAddCursor", { fg = p.diff.add_fg, bg = p.diff.add_inline })
  hl("NeogitDiffAddInline", { fg = p.diff.add_fg, bg = p.diff.add_inline, bold = true })

  hl("NeogitDiffDelete", { fg = p.diff.del_fg, bg = p.diff.del_bg })
  hl("NeogitDiffDeleteHighlight", { fg = p.diff.del_fg, bg = p.diff.del_bg })
  hl("NeogitDiffDeleteCursor", { fg = p.diff.del_fg, bg = p.diff.del_inline })
  hl("NeogitDiffDeleteInline", { fg = p.diff.del_fg, bg = p.diff.del_inline, bold = true })

  -- Neogit Navigation & Metadata
  hl("NeogitSectionHeader", { fg = p.accent.primary, bold = true })
  hl("NeogitSectionHeaderCount", { fg = p.accent.primary })
  hl("NeogitHeading", { fg = p.accent.primary, bold = true })
  hl("NeogitCommitViewHeader", { fg = p.fg_bright, bg = p.bg_subtle, bold = true })
  hl("NeogitCommitViewDescription", { fg = p.accent.warm_dim })
  hl("NeogitFilePath", { fg = p.accent.primary, italic = true })
  hl("NeogitBranch", { fg = p.accent.primary, bold = true })
  hl("NeogitBranchHead", { fg = p.accent.primary, bold = true, underline = true })
  hl("NeogitRemote", { fg = p.diagnostic.hint, bold = true })
  hl("NeogitObjectId", { fg = p.fg_muted })
  hl("NeogitStash", { fg = p.fg_muted })
  hl("NeogitRebaseDone", { fg = p.fg_muted })

  -- Neogit Status Changes
  hl("NeogitChangeModified", { fg = p.diagnostic.warn })
  hl("NeogitChangeAdded", { fg = p.diagnostic.hint })
  hl("NeogitChangeDeleted", { fg = p.diagnostic.error })
  hl("NeogitChangeRenamed", { fg = p.diagnostic.info })
  hl("NeogitChangeUpdated", { fg = p.diagnostic.warn })
  hl("NeogitChangeCopied", { fg = p.diagnostic.hint })
  hl("NeogitChangeNewFile", { fg = p.diagnostic.hint })
  hl("NeogitChangeUnmerged", { fg = p.diagnostic.error })

  -- Mini.nvim
  hl("MiniCursorword", { underline = true })
  hl("MiniCursorwordCurrent", { underline = true })
  hl("MiniIndentscopeSymbol", { fg = p.accent.primary })
  hl("MiniJump", { bg = p.accent.primary, fg = p.bg })
  hl("MiniJump2dSpot", { fg = p.accent.primary, bold = true, nocombine = true })
  hl("MiniStarterCurrent", {})
  hl("MiniStarterHeader", { fg = p.fg_muted })
  hl("MiniStarterFooter", { fg = p.fg_faint, italic = true })
  hl("MiniStarterItem", { fg = p.fg })
  hl("MiniStarterItemBullet", { fg = p.fg_dim })
  hl("MiniStarterItemPrefix", { fg = p.diagnostic.warn })
  hl("MiniStarterQuery", { fg = p.accent.primary })
  hl("MiniStarterSection", { fg = p.accent.primary, bold = true })
  hl("MiniStatuslineDevinfo", { fg = p.fg_dim })
  hl("MiniStatuslineFileinfo", { fg = p.fg_dim })
  hl("MiniStatuslineFilename", { fg = p.fg })
  hl("MiniStatuslineInactive", { fg = p.fg_muted })
  hl("MiniStatuslineModeNormal", { fg = p.bg, bg = p.fg_muted, bold = true })
  hl("MiniStatuslineModeInsert", { fg = p.bg, bg = p.accent.primary, bold = true })
  hl("MiniStatuslineModeVisual", { fg = p.bg, bg = p.accent.secondary, bold = true })
  hl("MiniStatuslineModeReplace", { fg = p.bg, bg = p.diagnostic.error, bold = true })
  hl("MiniStatuslineModeCommand", { fg = p.bg, bg = p.accent.warm, bold = true })
  hl("MiniSurround", { bg = p.accent.primary, fg = p.bg })
  hl("MiniTablineCurrent", { fg = p.fg, bg = p.bg_highlight })
  hl("MiniTablineFill", { bg = p.bg_dim })
  hl("MiniTablineHidden", { fg = p.fg_muted, bg = p.bg_dim })
  hl("MiniTablineModifiedCurrent", { fg = p.diagnostic.warn, bg = p.bg_highlight })
  hl("MiniTablineModifiedHidden", { fg = p.diagnostic.warn, bg = p.bg_dim })
  hl("MiniTablineModifiedVisible", { fg = p.diagnostic.warn, bg = p.bg_highlight })
  hl("MiniTablineTabpagesection", { bg = p.bg_subtle })
  hl("MiniTablineVisible", { fg = p.fg, bg = p.bg_highlight })

  -- ==========================================================================
  -- Vim Syntax Highlights (legacy, for non-TS files)
  -- ==========================================================================
  hl("Constant", { fg = p.accent.warm })
  hl("String", { fg = p.accent.warm_dim })
  hl("Character", { fg = p.accent.warm_dim })
  hl("Number", { fg = p.accent.warm })
  hl("Boolean", { fg = p.accent.warm })
  hl("Float", { fg = p.accent.warm })

  hl("Identifier", { fg = p.fg })
  hl("Function", { fg = p.fg_bright })

  hl("Statement", { fg = p.accent.primary })
  hl("Conditional", { fg = p.accent.primary })
  hl("Repeat", { fg = p.accent.primary })
  hl("Label", { fg = p.fg_dim })
  hl("Operator", { fg = p.fg_dim })
  hl("Keyword", { fg = p.accent.primary })
  hl("Exception", { fg = p.accent.primary })

  hl("PreProc", { fg = p.fg_dim, italic = true })
  hl("Include", { fg = p.accent.primary })
  hl("Define", { fg = p.accent.primary })
  hl("Macro", { fg = p.accent.primary, italic = true })
  hl("PreCondit", { fg = p.fg_dim, italic = true })

  hl("Type", { fg = p.fg_bright })
  hl("StorageClass", { fg = p.accent.primary })
  hl("Structure", { fg = p.fg_bright })
  hl("Typedef", { fg = p.fg_bright })

  hl("Special", { fg = p.fg_dim })
  hl("SpecialChar", { fg = p.accent.warm })
  hl("Tag", { fg = p.fg_bright })
  hl("Delimiter", { fg = p.fg_dim })
  hl("SpecialComment", { fg = p.fg_dim, italic = true })
  hl("Debug", { fg = p.diagnostic.error })

  hl("Underlined", { fg = p.fg, underline = true })

  hl("Ignore", { fg = p.fg_faint })

  hl("Error", { fg = p.diagnostic.error })

  hl("Todo", { fg = p.diagnostic.info, bold = true })

  -- ==========================================================================
  -- Miscellaneous
  -- ==========================================================================

  -- Directory
  hl("Directory", { fg = p.fg_dim })

  -- EndOfBuffer
  hl("EndOfBuffer", { fg = p.fg_faint })

  -- Error messages
  hl("ErrorMsg", { fg = p.diagnostic.error })
  hl("WarningMsg", { fg = p.diagnostic.warn })
  hl("ModeMsg", { fg = p.fg_bright, bold = true })
  hl("MoreMsg", { fg = p.accent.primary })
  hl("Question", { fg = p.accent.primary })

  -- Whitespace
  hl("Whitespace", { fg = p.fg_faint })

  -- Wild menu
  hl("WildMenu", { fg = p.fg_bright, bg = p.bg_highlight, bold = true })

  return h
end

return M
