-- contrast.nvim
-- Minimalist OLED-optimized Neovim colorscheme with Tree-sitter support
-- Mono-scale color system for reduced eye fatigue

local M = {}

--- Plugin configuration
M.config = {
  -- Accent hue in degrees (0-360). Set to nil for default blue-gray (220).
  -- Common values: 0=red, 30=orange, 50=yellow, 120=green, 160=teal,
  --                200=cyan, 220=blue, 260=indigo, 280=purple, 320=pink
  accent = nil,

  -- Transparency: remove background for terminal transparency
  transparent = false,

  -- Cursor line: highlight current line
  cursorline = true,
}

local palette = require("contrast.palette")
local highlights = require("contrast.highlights")

--- Apply highlight groups based on current vim.o.background
function M.load()
  local mode = vim.o.background == "light" and "light" or "dark"
  local p = palette.get(mode)
  local h = highlights.build(p)

  -- Clear existing highlights
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  -- Set theme name
  vim.g.colors_name = "contrast"

  -- Apply all highlight groups
  for group, opts in pairs(h) do
    if opts.link then
      vim.api.nvim_set_hl(0, group, { link = opts.link })
    else
      local hl_opts = {}

      if opts.fg then hl_opts.fg = opts.fg end
      if opts.bg then hl_opts.bg = opts.bg end
      if opts.bold then hl_opts.bold = true end
      if opts.italic then hl_opts.italic = true end
      if opts.underline then hl_opts.underline = true end
      if opts.undercurl then hl_opts.undercurl = true end
      if opts.strikethrough then hl_opts.strikethrough = true end
      if opts.reverse then hl_opts.reverse = true end
      if opts.nocombine then hl_opts.nocombine = true end
      if opts.sp then hl_opts.sp = opts.sp end

      -- Handle transparency
      if M.config.transparent then
        if group == "Normal" or group == "NormalFloat" or group == "NormalNC" then
          hl_opts.bg = nil
        end
      end

      vim.api.nvim_set_hl(0, group, hl_opts)
    end
  end

  -- Handle transparency for other groups
  if M.config.transparent then
    local transparent_groups = {
      "NeoTreeNormal", "NeoTreeNormalNC",
      "Pmenu", "WhichKeyFloat", "LazyNormal", "MasonNormal",
    }
    for _, group in ipairs(transparent_groups) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      if hl and hl.bg then
        vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = nil })
      end
    end
  end

  -- Handle cursorline
  if not M.config.cursorline then
    pcall(function()
      vim.api.nvim_set_hl(0, "CursorLine", { bg = nil })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = p.fg_dim, bg = nil })
    end)
  end

  -- Set terminal colors (for :terminal)
  vim.g.terminal_color_0 = p.bg
  vim.g.terminal_color_1 = p.diagnostic.error
  vim.g.terminal_color_2 = p.diagnostic.hint
  vim.g.terminal_color_3 = p.diagnostic.warn
  vim.g.terminal_color_4 = p.diagnostic.info
  vim.g.terminal_color_5 = p.accent.primary
  vim.g.terminal_color_6 = p.accent.tertiary
  vim.g.terminal_color_7 = p.fg
  vim.g.terminal_color_8 = p.fg_faint
  vim.g.terminal_color_9 = p.diagnostic.error
  vim.g.terminal_color_10 = p.diagnostic.hint
  vim.g.terminal_color_11 = p.diagnostic.warn
  vim.g.terminal_color_12 = p.diagnostic.info
  vim.g.terminal_color_13 = p.accent.primary
  vim.g.terminal_color_14 = p.accent.tertiary
  vim.g.terminal_color_15 = p.fg_bright
end

--- Set accent color by hue and reapply
--- Color math runs once, palette is cached until next call
---@param hue number 0-360
function M.set_accent(hue)
  palette.set_accent(hue)
  M.load()
end

--- Get current accent hue
---@return number
function M.get_hue()
  return palette.get_hue()
end

--- Setup the colorscheme
---@param opts? table user configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Apply accent hue from config
  if M.config.accent then
    palette.set_accent(M.config.accent)
  end

  -- Re-apply when background changes
  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = function()
      M.load()
    end,
  })
end

return M
