-- contrast.nvim highlight groups
-- Tree-sitter native highlights with mono-scale color system

local M = {}

--- Build highlight groups for the given palette
---@param p table palette
---@return table highlights
function M.build(p)
  local h = {}

  -- Helper: create highlight spec
  local function hl(group, opts)
    h[group] = opts
  end

  -- Helper: link to another group
  local function link(group, target)
    h[group] = { link = target }
  end

  -- ==========================================================================
  -- Tree-sitter Highlights
  -- ==========================================================================
  -- Philosophy: Use brightness/saturation to indicate importance
  -- - Keywords/declarations: brightest accent (most important to notice)
  -- - Functions/calls: medium accent
  -- - Types/constructors: dimmer accent
  -- - Strings/constants: warm tone (subtle distinction)
  -- - Comments: muted foreground (visible but not distracting)

  -- Keywords: Most important - control flow, declarations
  -- These should catch your eye when scanning
  hl("@keyword", { fg = p.accent.primary, bold = true })
  hl("@keyword.function", { fg = p.accent.primary, bold = true })
  hl("@keyword.return", { fg = p.accent.primary, bold = true })
  hl("@keyword.operator", { fg = p.accent.primary })
  hl("@keyword.import", { fg = p.accent.primary })
  hl("@keyword.repeat", { fg = p.accent.primary })
  hl("@keyword.conditional", { fg = p.accent.primary })
  hl("@keyword.exception", { fg = p.accent.primary })
  hl("@keyword.coroutine", { fg = p.accent.primary })

  -- Control flow keywords (if/else/for/while/match)
  hl("@keyword.control", { fg = p.accent.primary, bold = true })
  hl("@keyword.control.conditional", { fg = p.accent.primary, bold = true })
  hl("@keyword.control.repeat", { fg = p.accent.primary, bold = true })
  hl("@keyword.control.return", { fg = p.accent.primary, bold = true })
  hl("@keyword.control.trycatch", { fg = p.accent.primary })

  -- Storage class / modifiers (pub, static, const, mut, etc.)
  hl("@keyword.storage", { fg = p.accent.secondary })
  hl("@keyword.storage.modifier", { fg = p.accent.secondary })
  hl("@keyword.storage.type", { fg = p.accent.secondary })

  -- Definitions: where names are being declared
  hl("@keyword.definition", { fg = p.accent.primary })
  hl("@keyword.definition.function", { fg = p.accent.primary })
  hl("@keyword.definition.method", { fg = p.accent.primary })
  hl("@keyword.definition.operator", { fg = p.accent.primary })
  hl("@keyword.definition.type", { fg = p.accent.primary })
  hl("@keyword.definition.enum", { fg = p.accent.primary })
  hl("@keyword.definition.enum.variant", { fg = p.accent.tertiary })
  hl("@keyword.definition.struct", { fg = p.accent.primary })
  hl("@keyword.definition.interface", { fg = p.accent.primary })
  hl("@keyword.definition.namespace", { fg = p.accent.primary })
  hl("@keyword.definition.module", { fg = p.accent.primary })

  -- Functions: Medium importance - calls and definitions
  hl("@function", { fg = p.fg_bright })
  hl("@function.builtin", { fg = p.fg })
  hl("@function.call", { fg = p.fg_bright })
  hl("@function.declaration", { fg = p.fg_bright, bold = true })
  hl("@function.method", { fg = p.fg_bright })
  hl("@function.method.call", { fg = p.fg_bright })

  -- Macros: Slightly different to stand out
  hl("@function.macro", { fg = p.accent.secondary, italic = true })

  -- Methods
  hl("@method", { fg = p.fg_bright })
  hl("@method.call", { fg = p.fg_bright })

  -- Constructors
  hl("@constructor", { fg = p.accent.tertiary })
  hl("@constructor.lua", { fg = p.fg })

  -- Types: Third tier - important but not as critical as keywords
  hl("@type", { fg = p.accent.tertiary })
  hl("@type.builtin", { fg = p.accent.tertiary })
  hl("@type.definition", { fg = p.accent.tertiary, bold = true })
  hl("@type.qualifier", { fg = p.accent.secondary })
  hl("@type.builtin.vim", { fg = p.accent.tertiary })
  hl("@type.builtinvim", { fg = p.accent.tertiary })

  -- Namespaces and modules
  hl("@namespace", { fg = p.accent.tertiary })
  hl("@module", { fg = p.accent.tertiary })
  hl("@module.builtin", { fg = p.accent.tertiary })

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
  hl("@comment", { fg = p.fg_muted, italic = true })
  hl("@comment.documentation", { fg = p.fg_dim, italic = true })
  hl("@comment.error", { fg = p.diagnostic.error, italic = true })
  hl("@comment.warning", { fg = p.diagnostic.warn, italic = true })
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
  hl("@tag", { fg = p.accent.tertiary })
  hl("@tag.attribute", { fg = p.fg })
  hl("@tag.delimiter", { fg = p.fg_dim })

  -- Attributes and decorators
  hl("@attribute", { fg = p.accent.secondary, italic = true })
  hl("@decorator", { fg = p.accent.secondary, italic = true })

  -- Labels
  hl("@label", { fg = p.accent.tertiary })

  -- Diff
  hl("@diff.plus", { fg = p.diagnostic.hint })
  hl("@diff.minus", { fg = p.diagnostic.error })
  hl("@diff.delta", { fg = p.diagnostic.warn })

  -- Error handling
  hl("@error", { fg = p.diagnostic.error })

  -- ==========================================================================
  -- Language-Specific Tree-sitter Groups
  -- ==========================================================================

  -- Rust
  hl("@type.rust", { fg = p.accent.tertiary })
  hl("@lsp.type.class.rust", { fg = p.accent.tertiary })
  hl("@lsp.type.enum.rust", { fg = p.accent.tertiary })
  hl("@lsp.type.enumMember.rust", { fg = p.accent.tertiary })

  -- Go
  hl("@type.go", { fg = p.accent.tertiary })
  hl("@type.builtin.go", { fg = p.accent.tertiary })

  -- TypeScript/JavaScript
  hl("@type.typescript", { fg = p.accent.tertiary })
  hl("@type.javascript", { fg = p.accent.tertiary })
  hl("@lsp.type.interface.typescript", { fg = p.accent.tertiary })
  hl("@lsp.type.type.typescript", { fg = p.accent.tertiary })

  -- Java
  hl("@type.java", { fg = p.accent.tertiary })
  hl("@type.builtin.java", { fg = p.accent.tertiary })
  hl("@type.annotation.java", { fg = p.accent.secondary, italic = true })

  -- Scala
  hl("@type.scala", { fg = p.accent.tertiary })

  -- C/C++
  hl("@type.c", { fg = p.accent.tertiary })
  hl("@type.cpp", { fg = p.accent.tertiary })
  hl("@type.builtin.c", { fg = p.accent.tertiary })
  hl("@type.builtin.cpp", { fg = p.accent.tertiary })

  -- Zig
  hl("@type.zig", { fg = p.accent.tertiary })

  -- Prolog
  hl("@type.prolog", { fg = p.accent.tertiary })

  -- Config files (YAML, JSON, TOML)
  hl("@property.yaml", { fg = p.fg_dim })
  hl("@property.json", { fg = p.fg_dim })
  hl("@property.toml", { fg = p.fg_dim })
  hl("@string.special.path.yaml", { fg = p.accent.warm_dim })
  hl("@string.special.path.json", { fg = p.accent.warm_dim })

  -- Lua
  hl("@variable.builtin.lua", { fg = p.accent.tertiary })
  hl("@constructor.lua", { fg = p.fg })
  hl("@property.lua", { fg = p.fg })

  -- Vim
  hl("@function.builtin.vim", { fg = p.fg })
  hl("@variable.builtin.vim", { fg = p.accent.tertiary })
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
  hl("MatchParen", { bg = p.match_paren })

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
  hl("IndentBlanklineChar", { fg = p.fg_faint })
  hl("IndentBlanklineContextChar", { fg = p.fg_dim })
  hl("IblIndent", { fg = p.fg_faint })
  hl("IblScope", { fg = p.fg_dim })

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

  -- Diffview
  hl("DiffAdd", { bg = p.visual })
  hl("DiffChange", { bg = p.visual })
  hl("DiffDelete", { fg = p.diagnostic.error })
  hl("DiffText", { bg = p.visual })

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
  hl("Label", { fg = p.accent.tertiary })
  hl("Operator", { fg = p.fg_dim })
  hl("Keyword", { fg = p.accent.primary })
  hl("Exception", { fg = p.accent.primary })

  hl("PreProc", { fg = p.accent.secondary })
  hl("Include", { fg = p.accent.secondary })
  hl("Define", { fg = p.accent.secondary })
  hl("Macro", { fg = p.accent.secondary, italic = true })
  hl("PreCondit", { fg = p.accent.secondary })

  hl("Type", { fg = p.accent.tertiary })
  hl("StorageClass", { fg = p.accent.secondary })
  hl("Structure", { fg = p.accent.tertiary })
  hl("Typedef", { fg = p.accent.tertiary })

  hl("Special", { fg = p.fg_dim })
  hl("SpecialChar", { fg = p.accent.warm })
  hl("Tag", { fg = p.accent.tertiary })
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
