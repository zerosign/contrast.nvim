-- contrast.nvim palette
-- Mono-scale color system optimized for OLED screens
-- Accent color is computed once on set_accent(), cached until next call

local color = require("contrast.color")

local M = {}

-- Cached palette (rebuilt only on set_accent or mode change)
local cached = { dark = nil, light = nil }
local current_hue = 220 -- default blue-gray

-- ============================================================================
-- Base palettes (accent-independent parts)
-- ============================================================================

local base_dark = {
  bg            = "#000000",
  bg_dim        = "#0a0a0a",
  bg_subtle     = "#111111",
  bg_highlight  = "#1a1a1e",

  fg            = "#c8c8cf",
  fg_bright     = "#ededf0",
  fg_dim        = "#8e8e98",
  fg_muted      = "#63636e",
  fg_faint      = "#3f3f48",

  cursor_line   = "#0d0d0d",
  indent        = "#18181c",
  border        = "#27272e",
  border_active = "#444450",
  none          = "NONE",
}

local base_light = {
  bg            = "#fafafa",
  bg_dim        = "#f4f4f5",
  bg_subtle     = "#e4e4e7",
  bg_highlight  = "#d4d4d8",

  fg            = "#27272a",
  fg_bright     = "#121214",
  fg_dim        = "#5c5c66",
  fg_muted      = "#797985",
  fg_faint      = "#a6a6b2",

  cursor_line   = "#f0f0f0",
  indent        = "#e4e4e7",
  border        = "#d4d4d8",
  border_active = "#9e9ea8",
  none          = "NONE",
}

-- ============================================================================
-- Accent generation (runs once per set_accent call)
-- ============================================================================

--- Generate accent colors from a hue (0-360)
---@param hue number
---@param dark boolean
---@return table accent
local function gen_accent(hue, dark)
  if dark then
    -- Dark mode: calibrated luminance hierarchy (passes WCAG AAA against OLED black)
    return {
      primary   = color.hsl_to_hex(hue, 52, 76),
      secondary = color.hsl_to_hex(hue, 42, 68),
      tertiary  = color.hsl_to_hex(hue, 38, 62),
      warm      = color.hsl_to_hex(38, 38, 74),  -- clean warm sand / gold
      warm_dim  = color.hsl_to_hex(38, 30, 65),  -- clean warm parchment
    }
  else
    -- Light mode: rich saturation, calibrated low lightness for high contrast against #fafafa
    return {
      primary   = color.hsl_to_hex(hue, 55, 28),
      secondary = color.hsl_to_hex(hue, 45, 34),
      tertiary  = color.hsl_to_hex(hue, 40, 39),
      warm      = color.hsl_to_hex(35, 55, 30),  -- deep warm bronze
      warm_dim  = color.hsl_to_hex(35, 45, 36),  -- rich warm sepia
    }
  end
end

--- Generate semantic/diagnostic colors shifted slightly from base hue
---@param hue number
---@param dark boolean
---@return table diagnostic
local function gen_diagnostic(hue, dark)
  if dark then
    return {
      error = color.hsl_to_hex(0,   48, 68),   -- clear soft red
      warn  = color.hsl_to_hex(38,  55, 68),   -- amber
      info  = color.hsl_to_hex(hue, 45, 72),   -- follows accent
      hint  = color.hsl_to_hex(160, 45, 68),   -- teal
    }
  else
    return {
      error = color.hsl_to_hex(0,   55, 36),
      warn  = color.hsl_to_hex(38,  70, 32),
      info  = color.hsl_to_hex(hue, 50, 32),
      hint  = color.hsl_to_hex(160, 55, 30),
    }
  end
end

--- Generate visual/UI accent colors
---@param hue number
---@param dark boolean
---@return table ui
local function gen_ui(hue, dark)
  if dark then
    return {
      visual      = color.hsl_to_hex(hue, 22, 15),
      match_paren = color.hsl_to_hex(hue, 22, 18),
    }
  else
    return {
      visual      = color.hsl_to_hex(hue, 25, 88),
      match_paren = color.hsl_to_hex(hue, 22, 84),
    }
  end
end

--- Build full palette for a mode at a given hue (cached)
---@param mode "dark" | "light"
---@param hue number 0-360
---@return table palette
local function build(mode, hue)
  local base = mode == "dark" and base_dark or base_light
  local dark = mode == "dark"
  local accent = gen_accent(hue, dark)
  local diag = gen_diagnostic(hue, dark)
  local ui = gen_ui(hue, dark)

  -- Merge into single palette table
  local p = {}
  for k, v in pairs(base) do p[k] = v end
  p.accent = accent
  p.diagnostic = diag
  p.visual = ui.visual
  p.match_paren = ui.match_paren
  return p
end

-- ============================================================================
-- Public API
-- ============================================================================

--- Get palette for mode (uses cache)
---@param mode "dark" | "light"
---@return table
function M.get(mode)
  mode = mode or "dark"
  if not cached[mode] then
    cached[mode] = build(mode, current_hue)
  end
  return cached[mode]
end

--- Set accent hue and rebuild palette cache
---@param hue number 0-360
function M.set_accent(hue)
  current_hue = hue % 360
  -- Invalidate both caches
  cached.dark = nil
  cached.light = nil
end

--- Get current accent hue
---@return number
function M.get_hue()
  return current_hue
end

return M
