-- contrast.nvim color utilities
-- HSL color space for generating mono-scale palettes

local M = {}

--- Parse hex color to RGB
---@param hex string hex color like "#8b9cc7"
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return
    tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16)
end

--- Convert RGB to hex
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return string hex like "#8b9cc7"
function M.rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x",
    math.max(0, math.min(255, math.floor(r + 0.5))),
    math.max(0, math.min(255, math.floor(g + 0.5))),
    math.max(0, math.min(255, math.floor(b + 0.5)))
  )
end

--- Convert RGB to HSL
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return number h 0-360
---@return number s 0-100
---@return number l 0-100
function M.rgb_to_hsl(r, g, b)
  r = r / 255
  g = g / 255
  b = b / 255

  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local h, s, l = 0, 0, (max + min) / 2

  if max ~= min then
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)

    if max == r then
      h = ((g - b) / d + (g < b and 6 or 0)) / 6
    elseif max == g then
      h = ((b - r) / d + 2) / 6
    else
      h = ((r - g) / d + 4) / 6
    end
  end

  return h * 360, s * 100, l * 100
end

--- Convert HSL to RGB
---@param h number 0-360
---@param s number 0-100
---@param l number 0-100
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.hsl_to_rgb(h, s, l)
  h = h / 360
  s = s / 100
  l = l / 100

  local r, g, b

  if s == 0 then
    r, g, b = l, l, l
  else
    local function hue2rgb(p, q, t)
      if t < 0 then t = t + 1 end
      if t > 1 then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r * 255, g * 255, b * 255
end

--- Convert hex to HSL
---@param hex string
---@return number h 0-360
---@return number s 0-100
---@return number l 0-100
function M.hex_to_hsl(hex)
  local r, g, b = M.hex_to_rgb(hex)
  return M.rgb_to_hsl(r, g, b)
end

--- Convert HSL to hex
---@param h number 0-360
---@param s number 0-100
---@param l number 0-100
---@return string hex
function M.hsl_to_hex(h, s, l)
  local r, g, b = M.hsl_to_rgb(h, s, l)
  return M.rgb_to_hex(r, g, b)
end

--- Generate a color with same hue, adjusted saturation and lightness
---@param hex string base color
---@param s_overwrite number|nil new saturation (0-100), nil keeps original
---@param l_overwrite number|nil new lightness (0-100), nil keeps original
---@return string hex
function M.adjust(hex, s_overwrite, l_overwrite)
  local h, s, l = M.hex_to_hsl(hex)
  return M.hsl_to_hex(h, s_overwrite or s, l_overwrite or l)
end

--- Blend two colors
---@param c1 string first hex color
---@param c2 string second hex color
---@param t number 0-1 blend factor (0=c1, 1=c2)
---@return string hex
function M.blend(c1, c2, t)
  local r1, g1, b1 = M.hex_to_rgb(c1)
  local r2, g2, b2 = M.hex_to_rgb(c2)
  return M.rgb_to_hex(
    r1 + (r2 - r1) * t,
    g1 + (g2 - g1) * t,
    b1 + (b2 - b1) * t
  )
end

--- Clamp a value between min and max
---@param val number
---@param min number
---@param max number
---@return number
function M.clamp(val, min, max)
  return math.max(min, math.min(max, val))
end

return M
