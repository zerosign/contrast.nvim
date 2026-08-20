-- Plugin configuration

local M = {}

---@class Config
---@field mode "dark" | "light"
---@field transparent boolean
---@field cursorline boolean
---@field integrations table<string, boolean>
M.defaults = {
  mode = "dark",
  transparent = false,
  cursorline = true,
  integrations = {
    treesitter = true,
    gitsigns = true,
    which_key = true,
    indent_blankline = true,
  },
}

local config = vim.deepcopy(M.defaults)

--- Merge user config with defaults
---@param opts? table
function M.setup(opts)
  if opts then
    config = vim.tbl_deep_extend("force", config, opts)
  end
  return config
end

--- Get current config
---@return Config
function M.get()
  return config
end

--- Reset to defaults
function M.reset()
  config = vim.deepcopy(M.defaults)
end

--- Toggle between dark and light mode
function M.toggle_mode()
  config.mode = config.mode == "dark" and "light" or "dark"
  return config.mode
end

return M
