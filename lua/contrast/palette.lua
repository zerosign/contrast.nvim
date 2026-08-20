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
  bg_highlight  = "#1a1a1a",

  fg            = "#d4d4d8",
  fg_bright     = "#e4e4e7",
  fg_dim        = "#a1a1aa",
  fg_muted      = "#71717a",
  fg_faint      = "#3f3f46",

  cursor_line   = "#0d0d0d",
  indent        = "#1a1a1a",
  border        = "#27272a",
  border_active = "#3f3f46",
  none          = "NONE",
}

local base_light = {
  bg            = "#fafafa",
  bg_dim        = "#f4f4f5",
  bg_subtle     = "#e4e4e7",
  bg_highlight  = "#d4d4d8",

  fg            = "#27272a",
  fg_bright     = "#18181b",
  fg_dim        = "#52525b",
  fg_muted      = "#71717a",
  fg_faint      = "#a1a1aa",

  cursor_line   = "#f0f0f0",
  indent        = "#e4e4e7",
  border        = "#d4d4d8",
  border_active = "#a1a1aa",
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
    -- Dark mode: lower lightness, moderate saturation
    return {
      primary   = color.hsl_to_hex(hue, 30, 60),
      secondary = color.hsl_to_hex(hue, 28, 52),
      tertiary  = color.hsl_to_hex(hue, 26, 45),
      warm      = color.hsl_to_hex(35, 12, 62),  -- warm gray (hue 35 = orange-gray)
      warm_dim  = color.hsl_to_hex(35, 10, 50),
    }
  else
    -- Light mode: higher saturation, lower lightness for contrast
    return {
      primary   = color.hsl_to_hex(hue, 35, 42),
      secondary = color.hsl_to_hex(hue, 33, 48),
      tertiary  = color.hsl_to_hex(hue, 30, 54),
      warm      = color.hsl_to_hex(35, 14, 38),
      warm_dim  = color.hsl_to_hex(35, 12, 50),
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
      error = color.hsl_to_hex(0,   30, 58),   -- red
      warn  = color.hsl_to_hex(40,  35, 58),   -- amber
      info  = color.hsl_to_hex(hue, 35, 55),   -- follows accent
      hint  = color.hsl_to_hex(160, 30, 55),   -- teal
    }
  else
    return {
      error = color.hsl_to_hex(0,   35, 48),
      warn  = color.hsl_to_hex(40,  35, 48),
      info  = color.hsl_to_hex(hue, 35, 48),
      hint  = color.hsl_to_hex(160, 30, 48),
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
      visual      = color.hsl_to_hex(hue, 20, 14),
      match_paren = color.hsl_to_hex(hue, 18, 16),
    }
  else
    return {
      visual      = color.hsl_to_hex(hue, 25, 88),
      match_paren = color.hsl_to_hex(hue, 22, 86),
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
